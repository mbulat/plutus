require 'spec_helper'

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

end