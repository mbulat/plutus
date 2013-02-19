require 'spec_helper'

module Plutus
  describe Revenue do
    it_behaves_like 'a Plutus::Account subtype', kind: :revenue, normal_balance: :credit
  end
end