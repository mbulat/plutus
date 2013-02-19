require 'spec_helper'

module Plutus
  describe CreditAmount do
    it_behaves_like 'a Plutus::Amount subtype', kind: :credit_amount
  end
end
