FactoryGirl.define do
  factory :entry, :class => Plutus::Entry do |entry|
    entry.description 'factory description'
    factory :entry_with_credit_and_debit do |entry_cd|
      entry_cd.after_build do |t|
        t.credit_amounts << FactoryGirl.build(:credit_amount, :entry => t)
        t.debit_amounts << FactoryGirl.build(:debit_amount, :entry => t)
      end
    end
  end

  factory :entry_no_description, :class => Plutus::Entry do |entry_cd|
    entry_cd.after_build do |t|
      t.credit_amounts << FactoryGirl.build(:credit_amount, :entry => t)
      t.debit_amounts << FactoryGirl.build(:debit_amount, :entry => t)
    end
  end
end
