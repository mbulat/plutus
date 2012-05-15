require 'spec_helper'

module Plutus
  describe CreditAmount do

    it "should be invalid without an amount" do
      credit_amount = FactoryGirl.build(:credit_amount, :amount => nil)
      credit_amount.should_not be_valid
    end

    it "should not be valid without a transaction" do
      credit_amount = FactoryGirl.build(:credit_amount, :transaction => nil)
      credit_amount.should_not be_valid
    end

    it "should not be valid without an account" do
      credit_amount = FactoryGirl.build(:credit_amount, :account => nil)
      credit_amount.should_not be_valid
    end

  end
end
