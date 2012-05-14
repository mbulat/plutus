require 'spec_helper'

module Plutus
  describe Asset do

    it "should allow creating an asset account" do
      asset = FactoryGirl.create(:asset)
    end

    it "should report a balance for the asset account" do
      asset = FactoryGirl.create(:asset)
      FactoryGirl.create(:debit_amount, :account => asset)
      asset.balance.should > 0
      asset.balance.should be_kind_of(BigDecimal)
    end

    it "should report a balance for the class of accounts" do
      asset = FactoryGirl.create(:asset)
      FactoryGirl.create(:debit_amount, :account => asset)
      Asset.should respond_to(:balance)
      Asset.balance.should > 0
      Asset.balance.should be_kind_of(BigDecimal)
    end

    it "should not report a trial balance" do
      lambda{Asset.trial_balance}.should raise_error(NoMethodError)
    end

    it "should not be valid without a name" do
      asset = FactoryGirl.build(:asset, :name => nil)
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
      contra_asset = Factory(:asset, :contra => true)
      # the odd amount below is because factories create an asset debit_amount
      FactoryGirl.create(:credit_amount, :account => contra_asset, :amount => 473) 
      contra_asset.balance.should > 0
      Asset.balance.should == 0 
    end

  end
end
