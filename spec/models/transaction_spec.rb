require 'spec_helper'

module Plutus
  describe Transaction do

    it "should create a transaction" do
      transaction = FactoryGirl.build(:transaction_with_credit_and_debit)
      transaction.save!
    end

    it "should not be valid without a credit amount" do
      transaction = FactoryGirl.build(:transaction)
      transaction.debit_amounts << FactoryGirl.build(:debit_amount, :transaction => transaction)
      transaction.should_not be_valid
      transaction.errors['base'].should include("Transaction must have at least one credit amount")
    end

    it "should not be valid with an invalid credit amount" do
      transaction = FactoryGirl.build(:transaction)
      transaction.debit_amounts << FactoryGirl.build(:debit_amount, :transaction => transaction)
      transaction.credit_amounts << FactoryGirl.build(:credit_amount, :transaction => transaction, :amount => nil)
      transaction.should_not be_valid
      transaction.errors[:credit_amounts].should == ["is invalid"]
    end

    it "should not be valid without a debit amount" do
      transaction = FactoryGirl.build(:transaction)
      transaction.credit_amounts << FactoryGirl.build(:credit_amount, :transaction => transaction)
      transaction.should_not be_valid
      transaction.errors['base'].should include("Transaction must have at least one debit amount")
    end

    it "should not be valid with an invalid debit amount" do
      transaction = FactoryGirl.build(:transaction)
      transaction.credit_amounts << FactoryGirl.build(:credit_amount, :transaction => transaction)
      transaction.debit_amounts << FactoryGirl.build(:debit_amount, :transaction => transaction, :amount => nil)
      transaction.should_not be_valid
      transaction.errors[:debit_amounts].should == ["is invalid"]
    end

    it "should not be valid without a description" do
      transaction = FactoryGirl.build(:transaction_with_credit_and_debit, :description => nil)
      transaction.should_not be_valid
      transaction.errors[:description].should == ["can't be blank"]
    end

    it "should require the debit and credit amounts to cancel" do
      transaction = FactoryGirl.build(:transaction)
      transaction.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 100, :transaction => transaction)
      transaction.debit_amounts << FactoryGirl.build(:debit_amount, :amount => 200, :transaction => transaction)
      transaction.should_not be_valid
      transaction.errors['base'].should == ["The credit and debit amounts are not equal"]
    end

    it "should have a polymorphic commercial document associations" do
      mock_document = FactoryGirl.create(:asset) # one would never do this, but it allows us to not require a migration for the test
      transaction = FactoryGirl.build(:transaction_with_credit_and_debit, :commercial_document => mock_document)
      transaction.save
      saved_transaction = Transaction.find(transaction.id)
      saved_transaction.commercial_document.should == mock_document
    end

    it "should allow building a transaction and credit and debits with a hash" do
      FactoryGirl.create(:asset, :name => "Accounts Receivable")
      FactoryGirl.create(:revenue, :name => "Sales Revenue")
      FactoryGirl.create(:liability, :name =>  "Sales Tax Payable")
      mock_document = FactoryGirl.create(:asset)
      transaction = Transaction.build(
        description: "Sold some widgets",
        commercial_document: mock_document,
        debits: [
          {account: "Accounts Receivable", amount: 50}], 
        credits: [
          {account: "Sales Revenue", amount: 45},
          {account: "Sales Tax Payable", amount: 5}])
      transaction.should be_valid
      transaction.save
      saved_transaction = Transaction.find(transaction.id)
      saved_transaction.commercial_document.should == mock_document
    end

  end
end
