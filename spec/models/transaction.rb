require 'spec_helper'

describe Transaction do

  it "should create a transaction" do
    transaction = Factory(:transaction)
  end
  
  it "should not be valid without a credit account" do
    transaction = Factory.build(:transaction, :credit_account => nil)
    transaction.should_not be_valid
  end
  
  it "should not be valid without a valid credit account" do
    bad_account = Factory.build(:asset, :name => nil)
    transaction = Factory.build(:transaction, :credit_account => bad_account)
    transaction.should_not be_valid
  end  

  it "should not be valid without a debit account" do
    transaction = Factory.build(:transaction, :debit_account => nil)
    transaction.should_not be_valid
  end
  
  it "should not be valid without a valid credit account" do
    bad_account = Factory.build(:asset, :name => nil)
    transaction = Factory.build(:transaction, :debit_account => bad_account)
    transaction.should_not be_valid
  end  

end