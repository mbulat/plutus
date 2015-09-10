namespace :dummy_data do
  desc "Clear dummy data"
  task :clear => :environment do
    Plutus::Entry.destroy_all
    Plutus::Asset.destroy_all
    Plutus::Liability.destroy_all
    Plutus::Revenue.destroy_all
    Plutus::Expense.destroy_all
  end

  desc "Generate dummy data for developing against"
  task :generate => :environment do
    # Create accounts
    Plutus::Asset.find_or_create_by!(name: 'Checking Account')
    Plutus::Asset.find_or_create_by!(name: 'Prepaid Fees')
    Plutus::Asset.find_or_create_by!(name: 'Accounts Receivable')

    Plutus::Liability.find_or_create_by!(name: 'Customer Deposits Held')
    Plutus::Liability.find_or_create_by!(name: 'State Tax Payable')
    Plutus::Liability.find_or_create_by!(name: 'Accounts Payable')

    Plutus::Revenue.find_or_create_by!(name: 'Sales Income')
    Plutus::Revenue.find_or_create_by!(name: 'Rental Income')

    Plutus::Expense.find_or_create_by!(name: 'Cleaning Fees')
    Plutus::Expense.find_or_create_by!(name: 'Payment Processing Fees')

    def random_asset_account
      Plutus::Asset.offset(rand(Plutus::Asset.count)).first.name
    end
    def random_liability_account
      Plutus::Liability.offset(rand(Plutus::Liability.count)).first.name
    end
    def random_revenue_account
      Plutus::Revenue.offset(rand(Plutus::Revenue.count)).first.name
    end
    def random_expense_account
      Plutus::Expense.offset(rand(Plutus::Expense.count)).first.name
    end
    def random_currency_amount
      (rand * 1000).round(2)
    end

    # Create a bunch of dummy entries so that reports are populated.
    100.times do |t|
      amount = random_currency_amount
      Plutus::Entry.create!(
        description: "Transfer record ##{t}",
        debits: [{account: random_asset_account, amount: amount}],
        credits: [{account: random_liability_account, amount: amount}],
        date: Date.today - t.days
      )

      amount = random_currency_amount * 2
      Plutus::Entry.create!(
        description: "Revenue record ##{t}",
        debits: [{account: random_asset_account, amount: amount}],
        credits: [{account: random_revenue_account, amount: amount}],
        date: Date.today - t.days
      )

      amount = random_currency_amount
      Plutus::Entry.create!(
        description: "Expense record ##{t}",
        debits: [{account: random_expense_account, amount: amount}],
        credits: [{account: random_asset_account, amount: amount}],
        date: Date.today - t.days
      )
    end
  end


end
