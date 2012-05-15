require 'spec_helper'

module Plutus
  describe Equity do

    it "should allow creating an equity account" do
      equity = FactoryGirl.create(:equity)
    end

    it "should report a balance for the equity account" do
      equity = FactoryGirl.create(:equity)
      FactoryGirl.create(:credit_amount, :account => equity)
      equity.balance.should > 0
      equity.balance.should be_kind_of(BigDecimal)
    end

    it "should report a balance for the class of accounts" do
      equity = FactoryGirl.create(:equity)
      FactoryGirl.create(:credit_amount, :account => equity)
      Equity.should respond_to(:balance)
      Equity.balance.should > 0
      Equity.balance.should be_kind_of(BigDecimal)
    end

    it "should not report a trial balance" do
      lambda{Equity.trial_balance}.should raise_error(NoMethodError)
    end

    it "should not be valid without a name" do
      equity = FactoryGirl.build(:equity, :name => nil)
      equity.should_not be_valid
    end

    it "should have many credit transactions" do
      equity = Factory(:equity)
      equity.should respond_to(:credit_transactions)
    end

    it "should have many debit transactions" do
      equity = Factory(:equity)
      equity.should respond_to(:debit_transactions)
    end

    it "a contra account should reverse the normal balance" do
      equity = FactoryGirl.create(:equity)
      contra_equity = Factory(:equity, :contra => true)
      FactoryGirl.create(:credit_amount, :account => equity)
      FactoryGirl.create(:debit_amount, :account => contra_equity)
      contra_equity.balance.should > 0
      Equity.balance.should == 0
    end

  end
end
