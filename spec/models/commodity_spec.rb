require 'spec_helper'

module Plutus
  describe Commodity do
    let(:usd) { FactoryGirl.create(:commodity, iso_code: "USD") }

    it "has one trading account" do
      usd.trading_account.should be_a(Plutus::Trading)
      usd.trading_account.should be_persisted
    end
  end
end
