require 'spec_helper'

module Plutus
  describe Liability do

    it "should allow creating an liability account" do
      liability = FactoryGirl.create(:liability)
    end

    it "should report a balance for the liability account" do
      liability = FactoryGirl.create(:liability)
      FactoryGirl.create(:credit_amount, :account => liability)
      liability.balance.should > 0
      liability.balance.should be_kind_of(BigDecimal)
    end

    it "should report a balance for the class of accounts" do
      liability = FactoryGirl.create(:liability)
      FactoryGirl.create(:credit_amount, :account => liability)
      Liability.should respond_to(:balance)
      Liability.balance.should > 0
      Liability.balance.should be_kind_of(BigDecimal)
    end

    it "should not report a trial balance" do
      lambda{Liability.trial_balance}.should raise_error(NoMethodError)
    end

    it "should not be valid without a name" do
      liability = FactoryGirl.build(:liability, :name => nil)
      liability.should_not be_valid
    end

    it "should have many credit transactions" do
      liability = Factory(:liability)
      liability.should respond_to(:credit_transactions)
    end

    it "should have many debit transactions" do
      liability = Factory(:liability)
      liability.should respond_to(:debit_transactions)
    end

    it "a contra account should reverse the normal balance" do
      liability = FactoryGirl.create(:liability)
      contra_liability = Factory(:liability, :contra => true)
      FactoryGirl.create(:credit_amount, :account => liability)
      FactoryGirl.create(:debit_amount, :account => contra_liability)
      contra_liability.balance.should > 0
      Liability.balance.should == 0
    end

  end
end