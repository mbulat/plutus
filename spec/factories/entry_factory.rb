FactoryBot.define do
  factory :entry, class: Plutus::Entry do |entry|
    entry.description { 'factory description' }

    factory :entry_with_credit_and_debit, class: Plutus::Entry do |entry_cd|
      credit_amounts { [association(:credit_amount, entry: build(:entry))] }
      debit_amounts { [association(:debit_amount, entry: build(:entry))] }
    end
  end
end
