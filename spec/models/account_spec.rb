require 'spec_helper'

module Plutus
  describe Account do

    it "should not allow creating an account without a subtype" do
      account = Factory.build(:account)
      account.should_not be_valid
    end

    it "should not have a balance method" do
      lambda{Account.balance}.should raise_error(NoMethodError)
    end

    it "should have a trial balance" do
      Account.should respond_to(:trial_balance)
      Account.trial_balance.should be_kind_of(BigDecimal)
    end

    it "should report a trial balance of 0 with correct transactions" do
      # credit accounts
      liability = Factory(:liability)
      equity = Factory(:equity)
      revenue = Factory(:revenue)
      contra_asset = Factory(:asset, :contra => true)
      contra_expense = Factory(:expense, :contra => true)

      # debit accounts
      asset = Factory(:asset)
      expense = Factory(:expense)
      contra_liability = Factory(:liability, :contra => true)
      contra_equity = Factory(:equity, :contra => true)
      contra_revenue = Factory(:revenue, :contra => true)

      Factory(:transaction, :credit_account =>  liability, :debit_account => asset, :amount => 100000)
      Factory(:transaction, :credit_account =>  equity, :debit_account => expense, :amount => 1000)
      Factory(:transaction, :credit_account =>  revenue, :debit_account => contra_liability, :amount => 40404)
      Factory(:transaction, :credit_account =>  contra_asset, :debit_account => contra_equity, :amount => 2)
      Factory(:transaction, :credit_account =>  contra_expense, :debit_account => contra_revenue, :amount => 333)

      Account.trial_balance.should == 0
    end

  end
end
