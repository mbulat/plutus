module Plutus
  # The Liability class is an account type used to represents debts owed to outsiders.
  #
  # === Normal Balance
  # The normal balance on Liability accounts is a *Credit*.
  #
  # @see http://en.wikipedia.org/wiki/Liability_(financial_accounting) Liability
  #
  # @author Michael Bulat
  class Liability < Account

    # The balance of the account.
    #
    # Liability accounts have normal credit balances, so the debits are subtracted from the credits
    # unless this is a contra account, in which credits are subtracted from debits
    #
    # @example
    #   >> liability.balance
    #   => #<Money fractional:250 currency:USD>
    #
    # @return [Money] The balance as a Money object
    def balance
      unless contra
        credits_balance - debits_balance
      else
        debits_balance - credits_balance
      end
    end

    # Balance of all Liability accounts
    #
    # @example
    #   >> Plutus::Liability.balance
    #   => 20
    #
    # @return [Integer] The fractional value as an integer
    def self.balance
      accounts_balance = 0
      accounts = self.all
      accounts.each do |liability|
        unless liability.contra
          accounts_balance += liability.balance.fractional
        else
          accounts_balance -= liability.balance.fractional
        end
      end
      accounts_balance
    end
  end
end
