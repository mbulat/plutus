module Plutus
  # The Account class represents accounts in the system. Each account must be subclassed as one of the following types:
  #
  #   TYPE        | NORMAL BALANCE    | DESCRIPTION
  #   --------------------------------------------------------------------------
  #   Asset       | Debit             | Resources owned by the Business Entity
  #   Liability   | Credit            | Debts owed to outsiders
  #   Equity      | Credit            | Owners rights to the Assets
  #   Revenue     | Credit            | Increases in owners equity
  #   Expense     | Debit             | Assets or services consumed in the generation of revenue
  #
  # Each account can also be marked as a "Contra Account". A contra account will have it's
  # normal balance swapped. For example, to remove equity, a "Drawing" account may be created
  # as a contra equity account as follows:
  #
  #   Plutus::Equity.create(:name => "Drawing", contra => true)
  #
  # At all times the balance of all accounts should conform to the "accounting equation"
  #   Plutus::Assets = Liabilties + Owner's Equity
  #
  # Each sublclass account acts as it's own ledger. See the individual subclasses for a
  # description.
  #
  # @abstract
  #   An account must be a subclass to be saved to the database. The Account class
  #   has a singleton method {trial_balance} to calculate the balance on all Accounts.
  #
  # @see http://en.wikipedia.org/wiki/Accounting_equation Accounting Equation
  # @see http://en.wikipedia.org/wiki/Debits_and_credits Debits, Credits, and Contra Accounts
  #
  # @author Michael Bulat
  class Account < ActiveRecord::Base

    belongs_to :commodity
    has_many :credit_amounts, :extend => AmountsExtension, :class_name => 'Plutus::CreditAmount'
    has_many :debit_amounts, :extend => AmountsExtension, :class_name => 'Plutus::DebitAmount'
    has_many :credit_entries, :through => :credit_amounts, :source => :entry, :class_name => 'Plutus::Entry'
    has_many :debit_entries, :through => :debit_amounts, :source => :entry, :class_name => 'Plutus::Entry'

    validates_presence_of :type, :name
    validates_uniqueness_of :name

    # The credit balance for the account.
    #
    # @example
    #   >> asset.credits_balance
    #   => #<BigDecimal:103259bb8,'0.1E4',4(12)>
    #
    # @return [BigDecimal] The decimal value credit balance
    def credits_balance
      if commodity_id
        credits_balance_interim = credit_amounts.joins(:entry).
          where("plutus_entries.commodity_id = ?", commodity_id).balance

        credits_balance_interim += credit_amounts.joins(:entry).
          where("plutus_entries.commodity_id <> ?", commodity_id).balance(false)

        credits_balance_interim
      else
        credit_amounts.balance
      end
    end

    # The debit balance for the account.
    #
    # @example
    #   >> asset.debits_balance
    #   => #<BigDecimal:103259bb8,'0.3E4',4(12)>
    #
    # @return [BigDecimal] The decimal value credit balance
    def debits_balance
      if commodity_id
        debits_balance_interim = debit_amounts.joins(:entry).
          where("plutus_entries.commodity_id = ?", commodity_id).balance
        debits_balance_interim += debit_amounts.joins(:entry).
          where("plutus_entries.commodity_id <> ?", commodity_id).balance(false)

        debits_balance_interim
      else
        debit_amounts.balance
      end
    end

    # This class method is used to return the balance for subclasses accounts.
    # It could not be used directly for this class.
    # Take a look on this method of subclasses for examples.
    #
    # @return [BigDecimal] The decimal value balance
    def self.balance(commodity = nil)
      if self == Account
        raise(NoMethodError, "undefined method 'balance'")
      else
        accounts_balance = BigDecimal.new('0')
        accounts = commodity ? where(commodity: commodity) : self.all
        accounts.each do |account|
          unless account.contra
            accounts_balance += account.balance
          else
            accounts_balance -= account.balance
          end
        end
        accounts_balance
      end
    end

    # The trial balance of all accounts in the system. This should always equal zero,
    # otherwise there is an error in the system.
    #
    # @example
    #   >> Account.trial_balance.to_i
    #   => 0
    #
    # @return [BigDecimal] The decimal value balance of all accounts
    def self.trial_balance
      unless self == Account
        raise(NoMethodError, "undefined method 'trial_balance'")
      else
        if Commodity.count > 1
          commodity_balances = Commodity.all.map do |commodity|
            Asset.balance(commodity) - Liability.balance(commodity) -
              Equity.balance(commodity) - Revenue.balance(commodity) +
              Expense.balance(commodity) - Trading.balance(commodity)
          end
          commodity_balances.reduce(:+)
        else
          Asset.balance - (Liability.balance + Equity.balance + Revenue.balance - Expense.balance)
        end
      end
    end

  end
end
