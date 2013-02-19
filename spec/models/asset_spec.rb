require 'spec_helper'

module Plutus
  describe Asset do
    it_behaves_like 'a Plutus::Account subtype', kind: :asset, normal_balance: :debit
  end
end
