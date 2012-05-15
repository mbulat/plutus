FactoryGirl.define do
  factory :amount, :class => Plutus::Amount do |amount|
    amount.amount BigDecimal.new('473')
    amount.association :transaction, :factory => :transaction_with_credit_and_debit
    amount.association :account, :factory => :asset
  end

  factory :credit_amount, :class => Plutus::CreditAmount do |credit_amount|
    credit_amount.amount BigDecimal.new('473')
    credit_amount.association :transaction, :factory => :transaction_with_credit_and_debit
    credit_amount.association :account, :factory => :revenue
  end

  factory :debit_amount, :class => Plutus::DebitAmount do |debit_amount|
    debit_amount.amount BigDecimal.new('473')
    debit_amount.association :transaction, :factory => :transaction_with_credit_and_debit
    debit_amount.association :account, :factory => :asset
  end
end
