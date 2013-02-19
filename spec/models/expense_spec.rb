require 'spec_helper'

module Plutus
  describe Expense do
    it_behaves_like 'a Plutus::Account subtype', kind: :expense, normal_balance: :debit
  end
end
