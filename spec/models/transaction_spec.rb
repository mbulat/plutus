require 'spec_helper'

module Plutus
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

    it "should not be valid without an amount" do
      transaction = Factory.build(:transaction, :amount => nil)
      transaction.should_not be_valid
    end

    it "should not be valid without a description" do
      transaction = Factory.build(:transaction, :description => nil)
      transaction.should_not be_valid
    end

    it "should have a polymorphic commercial document associations" do
      mock_document = Factory(:transaction) # one would never do this, but it allows us to not require a migration for the test
      transaction = Factory(:transaction, :commercial_document => mock_document)
      saved_transaction = Transaction.find(transaction.id)
      saved_transaction.commercial_document.should == mock_document
    end

  end
end
