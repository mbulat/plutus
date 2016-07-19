FactoryGirl.define do
  factory :asset, class: 'Plutus::Asset' do
    sequence(:name) { |n| "Factory Name #{n + rand(1000)}" }
    contra false
    type 'Finance::Asset'
  end
end
