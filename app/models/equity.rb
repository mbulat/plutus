class Equity < Account
  def credits_total
    credits_total = BigDecimal.new('0')
    credit_transactions.each do |credit_transaction|
      credits_total = credits_total + credit_transaction.amount
    end
    return credits_total
  end

  def debits_total
    debits_total = BigDecimal.new('0')
    debit_transactions.each do |debit_transaction|
      debits_total = debits_total + debit_transaction.amount
    end
    return debits_total
  end
  
  # Equity has credit balances, so we need to subtract the debits from the credits
  # unless this is a contra account, in which case the normal balance is reversed
  def balance
    unless contra
      credits_total - debits_total
      
    else
      debits_total - credits_total
    end    
  end
  
  # Balance of all Equity accounts
  #
  # @example
  #   >> Equity.balance
  #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
  def self.balance
    accounts_balance = BigDecimal.new('0') 
    accounts = self.find(:all)
    accounts.each do |equity|
      unless equity.contra
        accounts_balance += equity.balance
      else
        accounts_balance -= equity.balance
      end
    end
    accounts_balance
  end
end
