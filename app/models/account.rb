#
# == Overview:
#
# The Account class represents accounts in the system. Each account must be subclassed as one of the following types:
#
#   TYPE        | NORMAL BALANCE    | DESCRIPTION
#   --------------------------------------------------------------------------
#   Asset       | Debit             | Resources owned by the Business Entity
#   Liability   | Credit            | Debts owed to outsiders
#   Equity      | Credit            | Owners rights to the Assets
#   Revenue     | Credit            | Increases in owners equity
#   Expense     | Debit             | Assets or services consumed in the generation of revenue
#
# Each account can also be marked as a "Contra Account". A contra account will have it's 
# normal balance swapped. For example, to remove equity, a "Drawing" account may be created
# as a contra equity account as follows:
#
#   Equity.create(:name => "Drawing", contra => true)
#
# At all times the balance of all accounts should conform to the "accounting equation"
#   Assets = Liabilties + Owner's Equity
#
# Each sublclass account acts as it's own ledger. See the individual subclasses for a 
# description.
#
# @abstract 
#   An account must be a subclass to be saved to the database. The Account class 
#   has a singleton method {trial_balance} to calculate the balance on all Accounts.
#
# @see http://en.wikipedia.org/wiki/Accounting_equation Accounting Equation
# @see http://en.wikipedia.org/wiki/Debits_and_credits Debits, Credits, and Contra Accounts
# 
# @author Michael Bulat
class Account < ActiveRecord::Base
  
  validates_presence_of :type, :name
  
  has_many :credit_transactions,  :class_name => "Transaction", :foreign_key => "credit_account_id"
  has_many :debit_transactions,  :class_name => "Transaction", :foreign_key => "debit_account_id"      
  
  # The trial balance of all accounts in the system. This should always equal zero, 
  # otherwise there is an error in the system.
  # 
  # @example
  #   >> Account.trial_balance.to_i
  #   => 0
  #
  # @return [BigDecimal] The decimal value balance of all accounts
  def self.trial_balance
    unless self.new.class == Account
      raise(NoMethodError, "undefined method 'trial_balance'")
    else
      Asset.balance - (Liability.balance + Equity.balance + Revenue.balance - Expense.balance)
    end
  end

end
