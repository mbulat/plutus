FactoryGirl.define do
  factory :account, :class => Plutus::Account do |account|
    account.name
    account.contra { false }
  end

  factory :asset, :class => Plutus::Asset do |account|
    account.name
    account.contra { false }
  end

  factory :equity, :class => Plutus::Equity do |account|
    account.name
    account.contra { false }
  end

  factory :expense, :class => Plutus::Expense do |account|
    account.name
    account.contra { false }
  end

  factory :liability, :class => Plutus::Liability do |account|
    account.name
    account.contra { false }
  end

  factory :revenue, :class => Plutus::Revenue do |account|
    account.name
    account.contra { false }
  end

  sequence :name do |n|
    "Factory Name #{n}"
  end
end
