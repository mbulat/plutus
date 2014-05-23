module Plutus
  # The Equity class is an account type used to represents owners rights to the assets.
  #
  # === Normal Balance
  # The normal balance on Equity accounts is a *Credit*.
  #
  # @see http://en.wikipedia.org/wiki/Equity_(finance) Equity
  #
  # @author Michael Bulat
  class Trading < Account

    # The balance of the account.
    #
    # Equity accounts have normal credit balances, so the debits are subtracted from the credits
    # unless this is a contra account, in which credits are subtracted from debits
    #
    # @example
    #   >> asset.balance
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    def balance
      unless contra
        credits_balance - debits_balance
      else
        debits_balance - credits_balance
      end
    end

    # This class method is used to return
    # the balance of all Equity accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Plutus::Equity.balance
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #   >> Plutus::Asset.balance(commodity)
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #
    # @param commodity [Commodity] of balanced accounts or nil
    #
    # @return [BigDecimal] The decimal value balance
    def self.balance(commodity = nil)
      super
    end
  end
end
