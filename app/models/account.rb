# The Account presents accounts in the system
#
# Each account must be subclassed as one of the following types:
#
#   TYPE        | NORMAL BALANCE    | DESCRIPTION
#   --------------------------------------------------------------------------
#   Asset       | Debit             | Resources owned by the Business Entity
#   Liability   | Credit            | Debts owed to outsiders
#   Capital     | Credit            | Owners rights to the Assets
#   Drawing     | Debit             | Withdrawls made by owners
#   Revenue     | Credit            | Increases in owners equity
#   Expense     | Debit             | Assets or services consumed in the generation of revenue
#
# At all times the balance of all accounts should conform to the "accounting equation"
#   Assets = Liabilties + Owner's Equity
#
# @see http://en.wikipedia.org/wiki/Accounting_equation Accounting Equation
# 
# @author Michael Bulat
class Account < ActiveRecord::Base
  
  validates_presence_of :type, :name
  
  has_many :credit_transactions,  :class_name => "Transaction", :foreign_key => "credit_account_id"
  has_many :debit_transactions,  :class_name => "Transaction", :foreign_key => "debit_account_id"      

  # Balance of account subtype.
  #
  # @example
  #   >> Asset.balance
  #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
  def self.balance
    if self.new.class == Account
      raise(NoMethodError, "undefined method 'balance'")
    else
      accounts_balance = BigDecimal.new('0') 
      accounts = self.find(:all)
      accounts.each do |asset|
        accounts_balance += asset.balance
      end
      accounts_balance
    end
  end
  
  # The trial balance can be used for proof that all credits and
  # debits are in balance. 
  # 
  # @example
  #   >> Account.trial_balance.to_i
  #   => 0
  def self.trial_balance
    unless self.new.class == Account
      raise(NoMethodError, "undefined method 'balance'")
    else
      Asset.balance - (Liability.balance + Capital.balance + Revenue.balance - Expense.balance - Drawing.balance)
    end
  end

end
