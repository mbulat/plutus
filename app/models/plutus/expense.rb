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

    self.normal_credit_balance = false

    # The balance of the account.
    #
    # Expenses have normal debit balances, so the credits are subtracted from the debits
    # unless this is a contra account, in which debits are subtracted from credits
    #
    # Takes an optional hash specifying :from_date and :to_date for calculating balances during periods.
    # :from_date and :to_date may be strings of the form "yyyy-mm-dd" or Ruby Date objects
    #
    # @example
    #   >> expense.balance({:from_date => "2000-01-01", :to_date => Date.today})
    #   => #<BigDecimal:103259bb8,'0.1E4',4(12)>
    #
    # @example
    #   >> expense.balance
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    def balance(options={})
      super
    end

    # This class method is used to return
    # the balance of all Expense accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # Takes an optional hash specifying :from_date and :to_date for calculating balances during periods.
    # :from_date and :to_date may be strings of the form "yyyy-mm-dd" or Ruby Date objects
    #
    # @example
    #   >> Plutus::Expense.balance({:from_date => "2000-01-01", :to_date => Date.today})
    #   => #<BigDecimal:103259bb8,'0.1E4',4(12)>
    #
    # @example
    #   >> Plutus::Expense.balance
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #
    # @return [BigDecimal] The decimal value balance
    def self.balance(options={})
      super
    end
  end
end
