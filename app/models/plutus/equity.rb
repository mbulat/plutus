module Plutus
  # The Equity class is an account type used to represents owners rights to the assets.
  #
  # === Normal Balance
  # The normal balance on Equity accounts is a *Credit*.
  #
  # @see http://en.wikipedia.org/wiki/Equity_(finance) Equity
  #
  # @author Michael Bulat
  class Equity < Account

    self.normal_credit_balance = true

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
      super
    end

    # This class method is used to return
    # the balance of all Equity accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Plutus::Equity.balance
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #
    # @return [BigDecimal] The decimal value balance
    def self.balance
      super
    end
  end
end
