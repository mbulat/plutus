module Plutus
  # The Asset class is an account type used to represents resources owned by the business entity.
  #
  # === Normal Balance
  # The normal balance on Asset accounts is a *Debit*.
  #
  # @see http://en.wikipedia.org/wiki/Asset Assets
  #
  # @author Michael Bulat
  class Asset < Account

    # The balance of the account.
    #
    # Assets have normal debit balances, so the credits are subtracted from the debits
    # unless this is a contra account, in which debits are subtracted from credits
    #
    # @example
    #   >> asset.balance
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
    # the balance of all Asset accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Plutus::Asset.balance
    #   => 20
    #
    # @return [Integer] The fractional value as an integer
    def self.balance
      accounts_balance = 0
      accounts = self.all
      accounts.each do |asset|
        unless asset.contra
          accounts_balance += asset.balance.fractional
        else
          accounts_balance -= asset.balance.fractional
        end
      end
      accounts_balance
    end
  end
end
