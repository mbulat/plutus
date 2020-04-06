FactoryGirl.define do
  factory :amount, :class => Plutus::Amount do |amount|
    amount.amount BigDecimal('473')
    amount.association :entry, :factory => :entry_with_credit_and_debit
    amount.association :account, :factory => :asset
  end

  factory :credit_amount, :class => Plutus::CreditAmount do |credit_amount|
    credit_amount.amount BigDecimal('473')
    credit_amount.association :entry, :factory => :entry_with_credit_and_debit
    credit_amount.association :account, :factory => :revenue
  end

  factory :debit_amount, :class => Plutus::DebitAmount do |debit_amount|
    debit_amount.amount BigDecimal('473')
    debit_amount.association :entry, :factory => :entry_with_credit_and_debit
    debit_amount.association :account, :factory => :asset
  end
end
