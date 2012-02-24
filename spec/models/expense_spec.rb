require 'spec_helper'

module Plutus
  describe Expense do

    it "should allow creating an expense account" do
      expense = Factory(:expense)
    end

    it "should report a balance for the expense account" do
      expense = Factory(:expense)
      expense.balance.should be_kind_of(BigDecimal)
    end

    it "should report a balance for the class of accounts" do
      Expense.should respond_to(:balance)
      Expense.balance.should be_kind_of(BigDecimal)
    end

    it "should not report a trial balance" do
      lambda{Expense.trial_balance}.should raise_error(NoMethodError)
    end

    it "should not be valid without a name" do
      expense = Factory.build(:expense, :name => nil)
      expense.should_not be_valid
    end

    it "should have many credit transactions" do
      expense = Factory(:expense)
      expense.should respond_to(:credit_transactions)
    end

    it "should have many debit transactions" do
      expense = Factory(:expense)
      expense.should respond_to(:debit_transactions)
    end

    it "a contra account should reverse the normal balance" do
      expense = Factory(:expense)
      contra_expense = Factory(:expense, :contra => true)
      transaction = Factory(:transaction, :credit_account => contra_expense, :debit_account => expense, :amount => 1000)
      contra_expense.balance.should > 0
      Expense.balance.should == 0
    end

  end
end
