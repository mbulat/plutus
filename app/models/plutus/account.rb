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
    has_many :credit_amounts, :extend => AmountsExtension, :class_name => 'Plutus::CreditAmount'
    has_many :debit_amounts, :extend => AmountsExtension, :class_name => 'Plutus::DebitAmount'
    has_many :credit_entries, :through => :credit_amounts, :source => :entry, :class_name => 'Plutus::Entry'
    has_many :debit_entries, :through => :debit_amounts, :source => :entry, :class_name => 'Plutus::Entry'

    validates_presence_of :type

    if Plutus.enable_tenancy
      include Plutus::Tenancy
    else
      include Plutus::NoTenancy
    end

    # The credit balance for the account.
    #
    # @example
    #   >> asset.credits_balance
    #   => #<Money fractional:250 currency:USD>
    #
    # @return [Money] The credit balance as a Money object
    def credits_balance
      credit_amounts.balance
    end

    # The debit balance for the account.
    #
    # @example
    #   >> asset.debits_balance
    #   => #<Money fractional:250 currency:USD>
    #
    # @return [Money] The credit balance as a Money object
    def debits_balance
      debit_amounts.balance
    end

    # The trial balance of all accounts in the system. This should always equal zero,
    # otherwise there is an error in the system.
    #
    # @example
    #   >> Account.trial_balance.to_i
    #   => 0
    #
    # @return [Money] The balance of all accounts as a Money object
    def self.trial_balance
      unless self.new.class == Plutus::Account
        raise(NoMethodError, "undefined method 'trial_balance'")
      else
        Plutus::Asset.balance - (Plutus::Liability.balance + Plutus::Equity.balance + Plutus::Revenue.balance - Plutus::Expense.balance)
      end
    end

  end
end
