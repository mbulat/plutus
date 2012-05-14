require 'spec_helper'

module Plutus
  describe Revenue do

    it "should allow creating an revenue account" do
      revenue = FactoryGirl.create(:revenue)
    end

    it "should report a balance for the revenue account" do
      revenue = FactoryGirl.create(:revenue)
      FactoryGirl.create(:credit_amount, :account => revenue)
      revenue.balance.should > 0
      revenue.balance.should be_kind_of(BigDecimal)
    end

    it "should report a balance for the class of accounts" do
      revenue = FactoryGirl.create(:revenue)
      FactoryGirl.create(:credit_amount, :account => revenue)
      Revenue.should respond_to(:balance)
      Revenue.balance.should > 0
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
      contra_revenue = Factory(:revenue, :contra => true)
      # the odd amount below is because factories create an revenue debit_amount
      FactoryGirl.create(:debit_amount, :account => contra_revenue, :amount => 473) 
      contra_revenue.balance.should > 0
      Revenue.balance.should == 0 
    end

  end
end