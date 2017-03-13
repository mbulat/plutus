FactoryGirl.define do
  factory :credit_amount, class: 'Plutus::CreditAmount' do
    amount      BigDecimal.new('473')
    association :entry, factory: :entry_with_credit_and_debit
    association :account, factory: :revenue
  end
end
