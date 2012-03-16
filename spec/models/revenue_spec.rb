require 'spec_helper'

module Plutus
  describe Revenue do

    it "should allow creating a revenue account" do
      revenue = Factory(:revenue)
    end

    it "should report a balance for the revenue account" do
      revenue = Factory(:revenue)
      revenue.balance.should be_kind_of(BigDecimal)
    end

    it "should report a balance for the class of accounts" do
      Revenue.should respond_to(:balance)
      Revenue.balance.should be_kind_of(BigDecimal)
    end

    it "should not report a trial balance" do
      lambda{Revenue.trial_balance}.should raise_error(NoMethodError)
    end

    it "should not be valid without a name" do
      revenue = FactoryGirl.build(:revenue, :name => nil)
      revenue.should_not be_valid
    end

    it "should have many credit transactions" do
      revenue = Factory(:revenue)
      revenue.should respond_to(:credit_transactions)
    end

    it "should have many debit transactions" do
      revenue = Factory(:revenue)
      revenue.should respond_to(:debit_transactions)
    end

    it "a contra account should reverse the normal balance" do
      revenue = Factory(:revenue)
      contra_revenue = Factory(:revenue, :contra => true)
      transaction = Factory(:transaction, :credit_account => revenue, :debit_account => contra_revenue, :amount => 1000)
      contra_revenue.balance.should > 0
      Revenue.balance.should == 0
    end

  end
end
