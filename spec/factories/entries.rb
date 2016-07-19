FactoryGirl.define do
  factory :entry, class: 'Plutus::Entry' do
    description "Entry description"

    factory :entry_with_credit_and_debit, class: 'Plutus::Entry' do
      after(:build) do |entry_cd|
        entry_cd.credit_amounts << FactoryGirl.build(:credit_amount, entry: entry_cd)
        entry_cd.debit_amounts << FactoryGirl.build(:debit_amount, entry: entry_cd)
      end
    end

  end

end

