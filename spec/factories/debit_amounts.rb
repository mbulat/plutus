FactoryGirl.define do
  factory :debit_amount, class: 'Plutus::DebitAmount' do
    amount      BigDecimal.new('473')
    association :entry, factory: :entry_with_credit_and_debit
    association :account, factory: :asset
  end
end
