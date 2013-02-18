require 'spec_helper'

module Plutus
  describe Equity do
    it_behaves_like 'a Plutus::Account subtype', kind: :equity, normal_balance: :credit
  end
end
