module Plutus
  # Entries are the recording of debits and credits to various accounts.
  # This table can be thought of as a traditional accounting Journal.
  #
  # Posting to a Ledger can be considered to happen automatically, since
  # Accounts have the reverse 'has_many' relationship to either it's credit or
  # debit entries
  #
  # @example
  #   cash = Plutus::Asset.find_by_name('Cash')
  #   accounts_receivable = Plutus::Asset.find_by_name('Accounts Receivable')
  #
  #   debit_amount = Plutus::DebitAmount.new(:account => cash, :amount => 1000)
  #   credit_amount = Plutus::CreditAmount.new(:account => accounts_receivable, :amount => 1000)
  #
  #   entry = Plutus::Entry.new(:description => "Receiving payment on an invoice")
  #   entry.debit_amounts << debit_amount
  #   entry.credit_amounts << credit_amount
  #   entry.save
  #
  # @see http://en.wikipedia.org/wiki/Journal_entry Journal Entry
  #
  # @author Michael Bulat
  class Entry < ActiveRecord::Base
    belongs_to :commercial_document, :polymorphic => true
    belongs_to :commodity
    has_many :credit_amounts, :extend => AmountsExtension, :class_name => 'Plutus::CreditAmount'
    has_many :debit_amounts, :extend => AmountsExtension, :class_name => 'Plutus::DebitAmount'
    has_many :credit_accounts, :through => :credit_amounts, :source => :account, :class_name => 'Plutus::Account'
    has_many :debit_accounts, :through => :debit_amounts, :source => :account, :class_name => 'Plutus::Account'

    validates_presence_of :description
    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?
    validate :adjust_trading_accounts

    # should goes after adjusting trading accounts
    validate :has_been_balanced_per_commodities?

    # Simple API for building a entry and associated debit and credit amounts
    #
    # @example
    #   entry = Plutus::Entry.build(
    #     description: "Sold some widgets",
    #     debits: [
    #       {account: "Accounts Receivable", amount: 50}],
    #     credits: [
    #       {account: "Sales Revenue", amount: 45},
    #       {account: "Sales Tax Payable", amount: 5}])
    #
    # @return [Plutus::Entry] A Entry with built credit and debit objects ready for saving
    def self.build(hash)
      new(hash.slice(:description, :commercial_document)).build(hash)
    end

    def balance_per_commodities
      grouped_amounts = (credit_amounts + debit_amounts).group_by do |amount|
        amount.account.commodity_id
      end

      grouped_amounts.map do |comm_id, amounts|
        balance_for(amounts, commodity_id == comm_id)
      end.reduce(:+)
    end

    def balanced_per_commodities?
      return true unless commodity_id
      balance_per_commodities.zero?
    end

    def balance
      credit_amounts.balance - debit_amounts.balance
    end

    def balanced?
      balance.zero?
    end

    def build(hash)
      base_account = Account.find_by_name(hash[:debits].first[:account])
      base_commodity = base_account.commodity
      self.commodity = base_commodity if base_commodity

      hash[:debits].each do |debit_amount|
        debit_amounts << build_amount(:debit, debit_amount)
      end
      hash[:credits].each do |credit_amount|
        credit_amounts << build_amount(:credit, credit_amount)
      end
      self
    end

    def build_amount(type, amount_hash)
      amount_klass = type == :debit ? DebitAmount : CreditAmount
      account = Account.find_by_name(amount_hash[:account])
      amount_klass.new do |amount|
        amount.account = account
        if commodity == account.commodity
          amount.amount = amount.value = amount_hash[:amount]
        else
          amount.amount = amount_hash[:amount]
          if amount_hash[:value]
            amount.value = amount_hash[:value]
          else
            amount.value = commodity.exchange(amount.amount, account.commodity)
          end
        end
        amount.entry = self
      end
    end

    private
    def has_credit_amounts?
      errors[:base] << "Entry must have at least one credit amount" if self.credit_amounts.blank?
    end

    def has_debit_amounts?
      errors[:base] << "Entry must have at least one debit amount" if self.debit_amounts.blank?
    end

    def amounts_cancel?
      errors[:base] << "The credit and debit amounts are not equal" unless balanced?
    end

    def has_been_balanced_per_commodities?
      errors[:base] << "The entry is not balanced per commodities" unless balanced_per_commodities?
    end

    def adjust_trading_accounts
      return unless commodity_id

      grouped_amounts = (credit_amounts + debit_amounts).group_by do |amount|
        amount.account.commodity_id
      end

      grouped_amounts.each do |comm_id, amounts|

        commody = Commodity.includes(:trading_account).find(comm_id)
        trading_account = commody.trading_account

        commody_balance_direct = balance_for(amounts)
        commody_balance_reverse = balance_for(amounts, false)
        next if commody_balance_reverse.zero?

        if commody_balance_reverse > 0
          unless credit_amounts.detect { |a| a.account_id == trading_account.id }
            trading_amount = CreditAmount.new do |amount|
              amount.account = trading_account
              amount.amount =  commody_balance_direct.abs
              amount.value =  commody_balance_reverse.abs
              amount.entry = self
            end
            credit_amounts << trading_amount
          end
        else
          unless debit_amounts.detect { |a| a.account_id == trading_account.id }
            trading_amount = DebitAmount.new do |amount|
              amount.account = trading_account
              amount.amount =  commody_balance_direct.abs
              amount.value =  commody_balance_reverse.abs
              amount.entry = self
            end
            debit_amounts << trading_amount
          end
        end
      end
    end

    def balance_for(amounts, direct = true)
      balanced_field = (direct ? :amount : :value)
      commody_balance = BigDecimal.new('0')
      amounts.each do |amount|
        case amount
        when CreditAmount
          commody_balance -= BigDecimal.new(amount.send(balanced_field).to_s)
        when DebitAmount
          commody_balance += BigDecimal.new(amount.send(balanced_field).to_s)
        end
      end
      commody_balance
    end
  end
end
