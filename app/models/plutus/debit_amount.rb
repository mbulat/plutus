module Plutus
  # The DebitAmount class represents debit entries in the entry journal.
  #
  # @example
  #     debit_amount = Plutus::DebitAmount.new(:account => cash, :amount => 1000)
  #
  # @author Michael Bulat
  class DebitAmount < ::Plutus::Amount
  end
end
