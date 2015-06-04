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

    self.normal_credit_balance = true

    # The balance of the account.
    #
    # Revenue accounts have normal credit balances, so the debits are subtracted from the credits
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
    # the balance of all Revenue accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Plutus::Revenue.balance
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #
    # @return [BigDecimal] The decimal value balance
    def self.balance
      super
    end
  end
end
