require 'spec_helper'

module Plutus
  describe DebitAmount do
    it_behaves_like 'a Plutus::Amount subtype', kind: :debit_amount
  end
end
