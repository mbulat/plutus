module Plutus
  # The CreditAmount class represents credit entries in the entry journal.
  #
  # @example
  #     credit_amount = Plutus::CreditAmount.new(:account => revenue, :amount => 1000)
  #
  # @author Michael Bulat
  class CreditAmount < ::Plutus::Amount
  end
end
