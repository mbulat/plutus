FactoryGirl.define do
  factory :account, class: 'Plutus::Account' do
    type 'Finance::Asset'
    sequence(:name) do |n|
      "Name #{n} #{Plutus::Account.maximum(:id).nil? ? 1 : Plutus::Account.maximum(:id).next}"
    end
    contra false
  end

end
