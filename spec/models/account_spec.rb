require 'spec_helper'

module Plutus
  describe Account do
    let(:account) { FactoryGirl.build(:account) }
    subject { account }

    it { should_not be_valid }  # must construct a child type instead

    describe "when using a child type" do
      let(:account) { FactoryGirl.create(:account, type: "Finance::Asset") }
      it { should be_valid }

      it "should be unique per name" do
        conflict = FactoryGirl.build(:account, name: account.name, type: account.type)
        conflict.should_not be_valid
        conflict.errors[:name].should == ["has already been taken"]
      end
    end

    it { should_not respond_to(:balance) }

    describe ".trial_balance" do
      subject { Account.trial_balance }
      it { should be_kind_of BigDecimal }

      context "when given no entries" do
        it { should == 0 }
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

        it { should == 0 }
      end

      context "when given correct entries with multiple currencies" do

        # commodities
        let!(:usd) { FactoryGirl.create(:commodity, iso_code: "USD") }
        let!(:eur) { FactoryGirl.create(:commodity, iso_code: "EUR") }
        let!(:cad) { FactoryGirl.create(:commodity, iso_code: "CAD") }

        # credit account
        let(:equity) { FactoryGirl.create(:equity, commodity: usd) }

        # debit account
        let(:asset)  { FactoryGirl.create(:asset, commodity: eur) }

        # credit account
        let(:expense)  { FactoryGirl.create(:expense, commodity: cad) }

        before {

          # entering an initial balance, rate is EUR/USD = 0.5
          # 100 USD (equity) -> 50 EUR (asset)

          credit_equity = FactoryGirl.build(:credit_amount) do |ce|
            ce.account = equity
            ce.amount = ce.value = 100
          end

          debit_asset = FactoryGirl.build(:debit_amount) do |da|
            da.account = asset
            da.amount = 100
            da.value = 50
          end

          FactoryGirl.build(:entry) do |e|
            e.credit_amounts << credit_equity
            e.debit_amounts << debit_asset
            e.commodity = usd
          end.save!

          # doing some expense, rate is EUR/CAD = 0.25
          # 20 EUR (asset) -> 80 CAD (expense)

          credit_asset = FactoryGirl.build(:credit_amount) do |ce|
            ce.account = asset
            ce.amount = ce.value = 20
          end

          debit_expense = FactoryGirl.build(:debit_amount) do |da|
            da.account = expense
            da.amount = 20
            da.value = 80
          end

          FactoryGirl.build(:entry) do |e|
            e.credit_amounts << credit_asset
            e.debit_amounts << debit_expense
            e.commodity = usd
          end.save!

        }

        it do
          equity.commodity.should == usd
          asset.commodity.should == eur
          expense.commodity.should == cad
          equity.balance.should == BigDecimal.new('100')
          asset.balance.should == BigDecimal.new('30')
          expense.balance.should == BigDecimal.new('80')
          should == 0
        end
      end
    end
  end
end
