require 'spec_helper'

module Plutus
  describe Entry do
    let(:entry) { FactoryGirl.build(:entry) }
    subject { entry }

    it { should_not be_valid }

    context "with credit and debit" do
      let(:entry) { FactoryGirl.build(:entry_with_credit_and_debit) }
      it { should be_valid }
      
      it "should require a description" do
        entry.description = nil
        entry.should_not be_valid
      end
    end

    context "with a debit" do
      before {
        entry.debit_amounts << FactoryGirl.build(:debit_amount, entry: entry)
      }
      it { should_not be_valid }

      context "with an invalid credit" do
        before {
          entry.credit_amounts << FactoryGirl.build(:credit_amount, entry: entry, amount: nil)
        }
        it { should_not be_valid }
      end
    end

    context "with a credit" do
      before {
        entry.credit_amounts << FactoryGirl.build(:credit_amount, entry: entry)
      }
      it { should_not be_valid }

      context "with an invalid debit" do
        before {
          entry.debit_amounts << FactoryGirl.build(:debit_amount, entry: entry, amount: nil)
        }
        it { should_not be_valid }
      end
    end

    it "should require the debit and credit amounts to cancel" do
      entry.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 100, :entry => entry)
      entry.debit_amounts << FactoryGirl.build(:debit_amount, :amount => 200, :entry => entry)
      entry.should_not be_valid
      entry.errors['base'].should == ["The credit and debit amounts are not equal"]
    end

    it "should require the debit and credit amounts to cancel even with fractions" do
      entry = FactoryGirl.build(:entry)
      entry.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 100.1, :entry => entry)
      entry.debit_amounts << FactoryGirl.build(:debit_amount, :amount => 100.2, :entry => entry)
      entry.should_not be_valid
      entry.errors['base'].should == ["The credit and debit amounts are not equal"]
    end

    it "should have a polymorphic commercial document associations" do
      mock_document = FactoryGirl.create(:asset) # one would never do this, but it allows us to not require a migration for the test
      entry = FactoryGirl.build(:entry_with_credit_and_debit, commercial_document: mock_document)
      entry.save!
      saved_entry = Entry.find(entry.id)
      saved_entry.commercial_document.should == mock_document
    end

    it "should allow building an entry and credit and debits with a hash" do
      FactoryGirl.create(:asset, name: "Accounts Receivable")
      FactoryGirl.create(:revenue, name: "Sales Revenue")
      FactoryGirl.create(:liability, name: "Sales Tax Payable")
      mock_document = FactoryGirl.create(:asset)
      entry = Entry.build(
        description: "Sold some widgets",
        commercial_document: mock_document,
        debits: [
          {account: "Accounts Receivable", amount: 50}], 
        credits: [
          {account: "Sales Revenue", amount: 45},
          {account: "Sales Tax Payable", amount: 5}])
      entry.save!

      saved_entry = Entry.find(entry.id)
      saved_entry.commercial_document.should == mock_document
    end

  end
end
