FactoryGirl.define do
  factory :account do |account|
    account.name 'factory name'
    account.contra false
  end

  factory :asset do |account|
    account.name 'factory name'
    account.contra false
  end

  factory :equity do |account|
    account.name 'factory name'
    account.contra false
  end

  factory :expense do |account|
    account.name 'factory name'
    account.contra false
  end

  factory :liability do |account|
    account.name 'factory name'
    account.contra false
  end

  factory :revenue do |account|
    account.name 'factory name'
    account.contra false
  end
end
