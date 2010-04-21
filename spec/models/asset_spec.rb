require 'spec_helper'

describe Asset do
  
  it "should allow creating an asset account" do
    asset = Factory(:asset)
  end
  
  it "should report a balance for the asset account" do
    asset = Factory(:asset)
    asset.balance.should be_kind_of(BigDecimal)
  end
  
  it "should report a balance for the class of accounts" do
    Asset.should respond_to(:balance)
    Asset.balance.should be_kind_of(BigDecimal)
  end

  it "should not report a trial balance" do
    lambda{Asset.trial_balance}.should raise_error(NoMethodError)
  end

  it "should not be valid without a name" do
    asset = Factory.build(:asset, :name => nil)
    asset.should_not be_valid
  end
  
  it "should have many credit transactions" do
    asset = Factory(:asset)
    asset.should respond_to(:credit_transactions)
  end

  it "should have many debit transactions" do
    asset = Factory(:asset)
    asset.should respond_to(:debit_transactions)
  end

  it "a contra account should reverse the normal balance" do
    asset = Factory(:asset)
    contra_asset = Factory(:asset, :contra => true)
    transaction = Factory(:transaction, :credit_account => contra_asset, :debit_account => asset, :amount => 1000)
    contra_asset.balance.should > 0
    Asset.balance.should == 0
  end
    
end