require 'spec_helper'

module Plutus
  describe DebitAmount do

    it "should be invalid without an amount" do
      debit_amount = FactoryGirl.build(:debit_amount, :amount => nil)
      debit_amount.should_not be_valid
    end

    it "should not be valid without a transaction" do
      debit_amount = FactoryGirl.build(:debit_amount, :transaction => nil)
      debit_amount.should_not be_valid
    end

    it "should not be valid without an account" do
      debit_amount = FactoryGirl.build(:debit_amount, :account => nil)
      debit_amount.should_not be_valid
    end

  end
end