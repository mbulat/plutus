require 'spec_helper'

describe Drawing do
  
  it "should allow creating a drawing account" do
    account = Factory(:drawing)
  end
  
  it "should have a balance" do
    Drawing.should respond_to(:balance)
    Drawing.balance.should be_kind_of(BigDecimal)
  end

end