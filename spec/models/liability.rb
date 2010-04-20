require 'spec_helper'

describe Liability do
  
  it "should allow creating a liability account" do
    account = Factory(:liability)
  end
  
  it "should have a balance" do
    Liability.should respond_to(:balance)
    Liability.balance.should be_kind_of(BigDecimal)
  end

end