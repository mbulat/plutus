require 'spec_helper'

RSpec.describe Plutus::AmountsExtension do
  it 'finds the balance of a single commercial document', :aggregate_failures do
    asset = FactoryGirl.create(:asset)
    liability = FactoryGirl.create(:liability)
    doc1 = FactoryGirl.create(:equity) # need a dummy AR object
    doc2 = FactoryGirl.create(:equity) # need a dummy AR object

    ca1 = FactoryGirl.create(:credit_amount, account: liability, amount: 1000)
    ca2 = FactoryGirl.create(:credit_amount, account: liability, amount: 500)
    da1 = FactoryGirl.create(:debit_amount, account: asset, amount: 1000)
    da2 = FactoryGirl.create(:debit_amount, account: asset, amount: 500)

    FactoryGirl.create(:entry, credit_amounts: [ca1], debit_amounts: [da1], commercial_document: doc1)
    FactoryGirl.create(:entry, credit_amounts: [ca2], debit_amounts: [da2], commercial_document: doc2)

    expect(asset.balance).to eq(1500)
    expect(asset.balance(commercial_document: doc1)).to eq(1000)
    expect(asset.balance(commercial_document: doc2)).to eq(500)
    expect(asset.debits_balance).to eq(1500)
    expect(asset.debits_balance(commercial_document: doc1)).to eq(1000)
    expect(asset.debits_balance(commercial_document: doc2)).to eq(500)

    expect(liability.balance).to eq(1500)
    expect(liability.balance(commercial_document: doc1)).to eq(1000)
    expect(liability.balance(commercial_document: doc2)).to eq(500)
    expect(liability.credits_balance).to eq(1500)
    expect(liability.credits_balance(commercial_document: doc1)).to eq(1000)
    expect(liability.credits_balance(commercial_document: doc2)).to eq(500)
  end
end
