FactoryGirl.define do
  factory :amount, class: 'Plutus::Amount' do
    amount      BigDecimal.new('473')
    association :entry, factory: :entry_with_credit_and_debit
    association :account, factory: :asset
  end
end
