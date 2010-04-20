require 'spec_helper'

describe Capital do
  
  it "should allow creating a capital account" do
    account = Factory(:capital)
  end
  
  it "should have a balance" do
    Capital.should respond_to(:balance)
    Capital.balance.should be_kind_of(BigDecimal)
  end

end