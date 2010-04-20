class Asset < Account
  def credits_total
    credits_total = BigDecimal.new('0')
    credit_transactions.each do |credit_transaction|
      credits_total += credit_transaction.amount
    end
    return credits_total
  end

  def debits_total
    debits_total = BigDecimal.new('0')
    debit_transactions.each do |debit_transaction|
      debits_total += debit_transaction.amount
    end
    return debits_total
  end
  
  # Assets have debit balances, so we need to subtract the credits from the debits
  def balance
    debits_total - credits_total
  end  
end
