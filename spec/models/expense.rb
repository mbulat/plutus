require 'spec_helper'

describe Expense do
  
  it "should allow creating an expense account" do
    account = Factory(:expense)
  end
  
  it "should have a balance" do
    Expense.should respond_to(:balance)
    Expense.balance.should be_kind_of(BigDecimal)
  end

end