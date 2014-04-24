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

    # Balance of all Liability accounts
    #
    # @example
    #   >> Plutus::Liability.balance
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #   >> Plutus::Asset.balance(commodity)
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #
    # @param commodity [Commodity] of balanced accounts or nil
    def self.balance(commodity = nil)
      super
    end
  end
end
