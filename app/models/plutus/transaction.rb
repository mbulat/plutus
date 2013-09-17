module Plutus
  # Transactions are the recording of debits and credits to various accounts.
  # This table can be thought of as a traditional accounting Journal.
  #
  # Posting to a Ledger can be considered to happen automatically, since
  # Accounts have the reverse 'has_many' relationship to either it's credit or
  # debit transactions
  #
  # @example
  #   cash = Plutus::Asset.find_by_name('Cash')
  #   accounts_receivable = Plutus::Asset.find_by_name('Accounts Receivable')
  #
  #   debit_amount = Plutus::DebitAmount.new(:account => cash, :amount => 1000)
  #   credit_amount = Plutus::CreditAmount.new(:account => accounts_receivable, :amount => 1000)
  #
  #   transaction = Plutus::Transaction.new(:description => "Receiving payment on an invoice")
  #   transaction.debit_amounts << debit_amount
  #   transaction.credit_amounts << credit_amount
  #   transaction.save
  #
  # @see http://en.wikipedia.org/wiki/Journal_entry Journal Entry
  #
  # @author Michael Bulat
  class Transaction < ActiveRecord::Base
    belongs_to :commercial_document, :polymorphic => true
    has_many :credit_amounts, :extend => AmountsExtension
    has_many :debit_amounts, :extend => AmountsExtension
    has_many :credit_accounts, :through => :credit_amounts, :source => :account
    has_many :debit_accounts, :through => :debit_amounts, :source => :account

    validates_presence_of :description
    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?


    # Simple API for building a transaction and associated debit and credit amounts
    #
    # @example
    #   transaction = Plutus::Transaction.build(
    #     description: "Sold some widgets",
    #     debits: [
    #       {account: "Accounts Receivable", amount: 50}], 
    #     credits: [
    #       {account: "Sales Revenue", amount: 45},
    #       {account: "Sales Tax Payable", amount: 5}])
    #
    # @return [Plutus::Transaction] A Transaction with built credit and debit objects ready for saving
    def self.build(hash)
      transaction = Transaction.new(:description => hash[:description], :commercial_document => hash[:commercial_document])
      hash[:debits].each do |debit|
        a = Account.find_by_name(debit[:account])
        transaction.debit_amounts << DebitAmount.new(:account => a, :amount => debit[:amount], :transaction => transaction)
      end
      hash[:credits].each do |credit|
        a = Account.find_by_name(credit[:account])
        transaction.credit_amounts << CreditAmount.new(:account => a, :amount => credit[:amount], :transaction => transaction)
      end
      transaction
    end

    private
      def has_credit_amounts?
        errors[:base] << "Transaction must have at least one credit amount" if self.credit_amounts.blank?
      end

      def has_debit_amounts?
        errors[:base] << "Transaction must have at least one debit amount" if self.debit_amounts.blank?
      end

      def amounts_cancel?
        errors[:base] << "The credit and debit amounts are not equal" if credit_amounts.balance != debit_amounts.balance
      end
  end
end
