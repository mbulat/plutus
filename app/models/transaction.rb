# Transactions are the recording of debits and credits to various accounts. 
# This table can be thought of as a traditional accounting Journal. 
#
# Posting to a Ledger can be considered to happen automatically, since 
# Accounts have the reverse 'has_many' relationship to either it's credit or
# debit transactions 
#
# @example
#   # receiving payment on an invoice
#   cash = Asset.find_by_name('Cash')
#   accounts_receivable = Asset.find_by_name('Accounts Receivable')
#   transaction = Transaction.create(:debit_account => cash, :credit_account => accounts_receivable, :amount => 100)
class Transaction < ActiveRecord::Base
  belongs_to :credit_account, :class_name => "Account"
  belongs_to :debit_account, :class_name => "Account"
end
