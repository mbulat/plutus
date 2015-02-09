module Plutus
  # The Revenue class is an account type used to represents increases in owners equity.
  #
  # === Normal Balance
  # The normal balance on Revenue accounts is a *Credit*.
  #
  # @see http://en.wikipedia.org/wiki/Revenue Revenue
  #
  # @author Michael Bulat
  class Revenue < Account

    # The balance of the account.
    #
    # Revenue accounts have normal credit balances, so the debits are subtracted from the credits
    # unless this is a contra account, in which credits are subtracted from debits
    #
    # @example
    #   >> asset.balance
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

    # This class method is used to return
    # the balance of all Revenue accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Plutus::Revenue.balance
    #   => 20
    #
    # @return [Integer] The fractional value as an integer
    def self.balance
      accounts_balance = 0
      accounts = self.all
      accounts.each do |revenue|
        unless revenue.contra
          accounts_balance += revenue.balance.fractional
        else
          accounts_balance -= revenue.balance.fractional
        end
      end
      accounts_balance
    end
  end
end
