module Plutus
  # The Expense class is an account type used to represents assets or services consumed in the generation of revenue.
  #
  # === Normal Balance
  # The normal balance on Expense accounts is a *Debit*.
  #
  # @see http://en.wikipedia.org/wiki/Expense Expenses
  #
  # @author Michael Bulat
  class Expense < Account

    # The balance of the account.
    #
    # Expenses have normal debit balances, so the credits are subtracted from the debits
    # unless this is a contra account, in which debits are subtracted from credits
    #
    # @example
    #   >> expense.balance
    #   => #<Money fractional:250 currency:USD>
    #
    # @return [Money] The balance as a Money object
    def balance
      unless contra
        debits_balance - credits_balance
      else
        credits_balance - debits_balance
      end
    end

    # This class method is used to return
    # the balance of all Expense accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Plutus::Expense.balance
    #   => 20
    #
    # @return [Integer] The fractional value as an integer
    def self.balance
      accounts_balance = 0
      accounts = self.all
      accounts.each do |expense|
        unless expense.contra
          accounts_balance += expense.balance.fractional
        else
          accounts_balance -= expense.balance.fractional
        end
      end
      accounts_balance
    end
  end
end
