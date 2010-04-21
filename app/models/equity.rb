# The Equity class is an account type used to represents owners rights to the assets.
#
# === Normal Balance
# The normal balance on Equity accounts is a *Credit*. 
#
# @see http://en.wikipedia.org/wiki/Equity_(finance) Equity
#
# @author Michael Bulat
class Equity < Account
  
  # The credit balance for the account.
  # 
  # @example
  #   >> equity.credits_balance
  #   => #<BigDecimal:103259bb8,'0.3E4',4(12)> 
  #
  # @return [BigDecimal] The decimal value credit balance
  def credits_balance
    credits_balance = BigDecimal.new('0')
    credit_transactions.each do |credit_transaction|
      credits_balance = credits_balance + credit_transaction.amount
    end
    return credits_balance
  end

  # The debit balance for the account.
  # 
  # @example
  #   >> equity.debits_balance
  #   => #<BigDecimal:103259bb8,'0.1E4',4(12)> 
  #
  # @return [BigDecimal] The decimal value credit balance
  def debits_balance
    debits_balance = BigDecimal.new('0')
    debit_transactions.each do |debit_transaction|
      debits_balance = debits_balance + debit_transaction.amount
    end
    return debits_balance
  end
  
  
  # The balance of the account.
  #
  # Equity accounts have normal credit balances, so the debits are subtracted from the credits
  # unless this is a contra account, in which credits are subtracted from debits
  # 
  # @example
  #   >> asset.balance
  #   => #<BigDecimal:103259bb8,'0.2E4',4(12)> 
  #
  # @return [BigDecimal] The decimal value balance
  def balance
    unless contra
      credits_balance - debits_balance
    else
      debits_balance - credits_balance
    end    
  end
  
  # This class method is used to return
  # the balance of all Equity accounts.
  #
  # Contra accounts are automatically subtracted from the balance.
  #
  # @example
  #   >> Equity.balance
  #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
  #
  # @return [BigDecimal] The decimal value balance  
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
