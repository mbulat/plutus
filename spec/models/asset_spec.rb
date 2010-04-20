require 'spec_helper'

describe Asset do
  
  it "should allow creating an asset account" do
    account = Factory(:asset)
  end
  
  it "should have a balance" do
    Asset.should respond_to(:balance)
    Asset.balance.should be_kind_of(BigDecimal)
  end

end