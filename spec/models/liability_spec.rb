require 'spec_helper'

module Plutus
  describe Liability do
    it_behaves_like 'a Plutus::Account subtype', kind: :liability, normal_balance: :credit
  end
end