Factory.define :transaction, :class => Plutus::Transaction do |transaction|
  transaction.description 'factory description'
  transaction.credit_account {|credit_account| credit_account.association(:asset)}
  transaction.debit_account {|debit_account| debit_account.association(:revenue)}
  transaction.amount BigDecimal.new('100')
end
