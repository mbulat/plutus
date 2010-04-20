require 'spec_helper'

describe Revenue do
  
  it "should allow creating a revenue account" do
    account = Factory(:revenue)
  end
  
  it "should have a balance" do
    Revenue.should respond_to(:balance)
    Revenue.balance.should be_kind_of(BigDecimal)
  end

end