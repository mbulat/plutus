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
    class_attribute :normal_credit_balance

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

    # The balance of the account. This instance method is intended for use only
    # on instances of account subclasses.
    #
    # If the account has a normal credit balance, the debits are subtracted from the credits
    # unless this is a contra account, in which case credits are substracted from debits.
    #
    # For a normal debit balance, the credits are subtracted from the debits
    # unless this is a contra account, in which case debits are subtracted from credits.
    #
    # @example
    #   >> liability.balance
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    def balance
      unless self.class == Plutus::Account
        if self.normal_credit_balance ^ contra
          credits_balance - debits_balance
        else
          debits_balance - credits_balance
        end
      else
        raise(NoMethodError, "undefined method 'balance'")
      end
    end

    # The credit balance for the account.
    #
    # @example
    #   >> asset.credits_balance
    #   => #<BigDecimal:103259bb8,'0.1E4',4(12)>
    #
    # @return [BigDecimal] The decimal value credit balance
    def credits_balance
      credit_amounts.balance
    end

    # The debit balance for the account.
    #
    # @example
    #   >> asset.debits_balance
    #   => #<BigDecimal:103259bb8,'0.3E4',4(12)>
    #
    # @return [BigDecimal] The decimal value credit balance
    def debits_balance
      debit_amounts.balance
    end

    # This class method is used to return the balance of all accounts
    # for a given class and is intended for use only on account subclasses.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Plutus::Liability.balance
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #
    # @return [BigDecimal] The decimal value balance
    def self.balance
      unless self.new.class == Plutus::Account
        accounts_balance = BigDecimal.new('0')
        accounts = self.all
        accounts.each do |account|
          unless account.contra
            accounts_balance += account.balance
          else
            accounts_balance -= account.balance
          end
        end
        accounts_balance
      else
        raise(NoMethodError, "undefined method 'balance'")
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
      unless self.new.class == Plutus::Account
        raise(NoMethodError, "undefined method 'trial_balance'")
      else
        Plutus::Asset.balance - (Plutus::Liability.balance + Plutus::Equity.balance + Plutus::Revenue.balance - Plutus::Expense.balance)
      end
    end

  end
end
