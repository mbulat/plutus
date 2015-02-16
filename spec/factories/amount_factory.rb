FactoryGirl.define do
  factory :amount, :class => Plutus::Amount do |amount|
    amount.amount Money.new('473', "USD")
    amount.association :entry, :factory => :entry_with_credit_and_debit
    amount.association :account, :factory => :asset
  end

  factory :credit_amount, :class => Plutus::CreditAmount do |credit_amount|
    credit_amount.amount Money.new('473', "USD")
    credit_amount.association :entry, :factory => :entry_with_credit_and_debit
    credit_amount.association :account, :factory => :revenue
  end

  factory :debit_amount, :class => Plutus::DebitAmount do |debit_amount|
    debit_amount.amount Money.new('473', "USD")
    debit_amount.association :entry, :factory => :entry_with_credit_and_debit
    debit_amount.association :account, :factory => :asset
  end
end
