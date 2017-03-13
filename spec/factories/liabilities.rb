FactoryGirl.define do
  factory :liability, class: 'Plutus::Liability' do
    sequence(:name) do |n|
      "Name #{n} #{Plutus::Account.maximum(:id).nil? ? 1 : Plutus::Account.maximum(:id).next}"
    end
    contra false
    type 'Finance::Asset'
  end

end
