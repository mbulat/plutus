require 'spec_helper'

module Plutus
  describe Account do
    let(:account) { FactoryGirl.build(:account) }
    subject { account }

    it { is_expected.not_to be_valid }  # must construct a child type instead

    describe ".types" do
      it "lists the available types" do
        expect(described_class.types).
          to match_array([Asset, Equity, Expense, Liability, Revenue])
      end
    end

    describe "when using a child type" do
      let(:account) { FactoryGirl.create(:account, type: "Finance::Asset") }
      it { is_expected.to be_valid }

      it "should be unique per name" do
        conflict = FactoryGirl.build(:account, name: account.name, type: account.type)
        expect(conflict).not_to be_valid
        expect(conflict.errors[:name]).to eq(["has already been taken"])
      end
    end

    it "calling the instance method #balance should raise a NoMethodError" do
      expect { subject.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end

    it "calling the class method ::balance should raise a NoMethodError" do
      expect { subject.class.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end

    describe ".trial_balance" do
      subject { Account.trial_balance }
      it { is_expected.to be_kind_of BigDecimal }

      context "when given no entries" do
        it { is_expected.to eq(0) }
      end

      context "when given correct entries" do
        before {
          # credit accounts
          liability = FactoryGirl.create(:liability)
          equity = FactoryGirl.create(:equity)
          revenue = FactoryGirl.create(:revenue)
          contra_asset = FactoryGirl.create(:asset, :contra => true)
          contra_expense = FactoryGirl.create(:expense, :contra => true)
          # credit amounts
          ca1 = FactoryGirl.build(:credit_amount, :account => liability, :amount => 100000)
          ca2 = FactoryGirl.build(:credit_amount, :account => equity, :amount => 1000)
          ca3 = FactoryGirl.build(:credit_amount, :account => revenue, :amount => 40404)
          ca4 = FactoryGirl.build(:credit_amount, :account => contra_asset, :amount => 2)
          ca5 = FactoryGirl.build(:credit_amount, :account => contra_expense, :amount => 333)

          # debit accounts
          asset = FactoryGirl.create(:asset)
          expense = FactoryGirl.create(:expense)
          contra_liability = FactoryGirl.create(:liability, :contra => true)
          contra_equity = FactoryGirl.create(:equity, :contra => true)
          contra_revenue = FactoryGirl.create(:revenue, :contra => true)
          # debit amounts
          da1 = FactoryGirl.build(:debit_amount, :account => asset, :amount => 100000)
          da2 = FactoryGirl.build(:debit_amount, :account => expense, :amount => 1000)
          da3 = FactoryGirl.build(:debit_amount, :account => contra_liability, :amount => 40404)
          da4 = FactoryGirl.build(:debit_amount, :account => contra_equity, :amount => 2)
          da5 = FactoryGirl.build(:debit_amount, :account => contra_revenue, :amount => 333)

          FactoryGirl.create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1])
          FactoryGirl.create(:entry, :credit_amounts => [ca2], :debit_amounts => [da2])
          FactoryGirl.create(:entry, :credit_amounts => [ca3], :debit_amounts => [da3])
          FactoryGirl.create(:entry, :credit_amounts => [ca4], :debit_amounts => [da4])
          FactoryGirl.create(:entry, :credit_amounts => [ca5], :debit_amounts => [da5])
        }

        it { is_expected.to eq(0) }
      end
    end

    describe "#amounts" do
      it "returns all credit and debit amounts" do
        equity = FactoryGirl.create(:equity)
        asset = FactoryGirl.create(:asset)
        expense = FactoryGirl.create(:expense)

        investment = Entry.new(
          description: "Initial investment",
          date: Date.today,
          debits: [{ account_name: equity.name, amount: 1000 }],
          credits: [{ account_name: asset.name, amount: 1000 }],
        )
        investment.save

        purchase = Entry.new(
          description: "First computer",
          date: Date.today,
          debits: [{ account_name: asset.name, amount: 900 }],
          credits: [{ account_name: expense.name, amount: 900 }],
        )
        purchase.save

        expect(equity.amounts.size).to eq 1
        expect(asset.amounts.size).to eq 2
        expect(expense.amounts.size).to eq 1
      end
    end

    describe "#entries" do
      it "returns all credit and debit entries" do
        equity = FactoryGirl.create(:equity)
        asset = FactoryGirl.create(:asset)
        expense = FactoryGirl.create(:expense)

        investment = Entry.new(
          description: "Initial investment",
          date: Date.today,
          debits: [{ account_name: equity.name, amount: 1000 }],
          credits: [{ account_name: asset.name, amount: 1000 }],
        )
        investment.save

        purchase = Entry.new(
          description: "First computer",
          date: Date.today,
          debits: [{ account_name: asset.name, amount: 900 }],
          credits: [{ account_name: expense.name, amount: 900 }],
        )
        purchase.save

        expect(equity.entries.size).to eq 1
        expect(asset.entries.size).to eq 2
        expect(expense.entries.size).to eq 1
      end
    end

  end
end
