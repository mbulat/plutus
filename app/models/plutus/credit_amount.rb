module Plutus
  # The CreditAmount class represents credit entries in the transaction journal.
  #
  # @example
  #     credit_amount = Plutus::CreditAmount.new(:account => revenue, :amount => 1000)
  #
  # @author Michael Bulat
  class CreditAmount < Amount
  end
end
