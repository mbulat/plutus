require 'spec_helper'
require 'debug'

module Plutus
  describe Entry do
    let(:entry) { FactoryGirl.build(:entry) }
    subject { entry }

    it { is_expected.not_to be_valid } 

    context "with credit and debit" do
      let(:entry) { FactoryGirl.build(:entry_with_credit_and_debit) }
      it { is_expected.to be_valid }

      it "should require a description" do
        entry.description = nil
        expect(entry).not_to be_valid
      end
    end

    context "with a debit" do
      before {
        entry.debit_amounts << FactoryGirl.build(:debit_amount, entry: entry)
      }
      it { is_expected.not_to be_valid }

      context "with an invalid credit" do
        before {
          entry.credit_amounts << FactoryGirl.build(:credit_amount, entry: entry, amount: nil)
        }
        it { is_expected.not_to be_valid }
      end
    end

    context "with a credit" do
      before {
        entry.credit_amounts << FactoryGirl.build(:credit_amount, entry: entry)
      }
      it { is_expected.not_to be_valid }

      context "with an invalid debit" do
        before {
          entry.debit_amounts << FactoryGirl.build(:debit_amount, entry: entry, amount: nil)
        }
        it { is_expected.not_to be_valid }
      end
    end

    context "without a date" do
      let(:entry) { FactoryGirl.build(:entry_with_credit_and_debit, date: nil) }

      context "should assign a default date before being saved" do
        before { entry.save! }
        its(:date) { is_expected.to eq(Time.now.to_date) }
      end
    end

    it "should require the debit and credit amounts to cancel" do
      entry.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 100, :entry => entry)
      entry.debit_amounts << FactoryGirl.build(:debit_amount, :amount => 200, :entry => entry)
      expect(entry).not_to be_valid
      expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
    end

    it "should require the debit and credit amounts to cancel even with fractions" do
      entry = FactoryGirl.build(:entry)
      entry.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 100.1, :entry => entry)
      entry.debit_amounts << FactoryGirl.build(:debit_amount, :amount => 100.2, :entry => entry)
      expect(entry).not_to be_valid
      expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
    end

    it "should ignore debit and credit amounts marked for destruction to cancel" do
      entry.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 100, :entry => entry)
      debit_amount = FactoryGirl.build(:debit_amount, :amount => 100, :entry => entry)
      debit_amount.mark_for_destruction
      entry.debit_amounts << debit_amount
      expect(entry).not_to be_valid
      expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
    end

    it "should have a polymorphic commercial document associations" do
      mock_document = FactoryGirl.create(:asset) # one would never do this, but it allows us to not require a migration for the test
      entry = FactoryGirl.build(:entry_with_credit_and_debit, commercial_document: mock_document)
      entry.save!
      saved_entry = Entry.find(entry.id)
      expect(saved_entry.commercial_document).to eq(mock_document)
    end

    context "given a set of accounts" do
      let(:mock_document) { FactoryGirl.create(:asset) }
      let!(:accounts_receivable) { FactoryGirl.create(:asset, name: "Accounts Receivable") }
      let!(:sales_revenue) { FactoryGirl.create(:revenue, name: "Sales Revenue") }
      let!(:sales_tax_payable) { FactoryGirl.create(:liability, name: "Sales Tax Payable") }

      shared_examples_for 'a built-from-hash Plutus::Entry' do
        its(:credit_amounts) { is_expected.not_to be_empty }
        its(:debit_amounts) { is_expected.not_to be_empty }
        it { is_expected.to be_valid }

        context "when saved" do
          before { entry.save! }
          its(:id) { is_expected.not_to be_nil }

          context "when reloaded" do
            let(:saved_transaction) { Entry.find(entry.id) }
            subject { saved_transaction }
            it("should have the correct commercial document") {
              saved_transaction.commercial_document == mock_document
            }
          end
        end
      end

      describe ".new" do
        let(:entry) { Entry.new(hash) }
        subject { entry }

        context "when given a credit/debits hash with :account => Account" do
          let(:hash) {
            {
                description: "Sold some widgets",
                commercial_document: mock_document,
                debits: [{account: accounts_receivable, amount: 50}],
                credits: [
                    {account: sales_revenue, amount: 45},
                    {account: sales_tax_payable, amount: 5}
                ]
            }
          }
          include_examples 'a built-from-hash Plutus::Entry'
        end

        context "when given a credit/debits hash with :account_name => String" do
          let(:hash) {
            {
                description: "Sold some widgets",
                commercial_document: mock_document,
                debits: [{account_name: accounts_receivable.name, amount: 50}],
                credits: [
                    {account_name: sales_revenue.name, amount: 45},
                    {account_name: sales_tax_payable.name, amount: 5}
                ]
            }
          }
          include_examples 'a built-from-hash Plutus::Entry'
        end
      end

      describe ".build" do
        let(:entry) { Entry.build(hash) }
        subject { entry }

        before { ::ActiveSupport::Deprecation.silenced = true }
        after { ::ActiveSupport::Deprecation.silenced = false }

        context "when used at all" do
          let(:hash) { Hash.new }

          it("should be deprecated") {
            # .build is the only thing deprecated
            expect(::ActiveSupport::Deprecation).to receive(:warn).once
            entry
          }
        end

      end
    end

  end
end
