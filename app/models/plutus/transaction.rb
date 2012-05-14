module Plutus
  # Transactions are the recording of debits and credits to various accounts.
  # This table can be thought of as a traditional accounting Journal.
  #
  # Posting to a Ledger can be considered to happen automatically, since
  # Accounts have the reverse 'has_many' relationship to either it's credit or
  # debit transactions
  #
  # @example
  #   cash = Asset.find_by_name('Cash')
  #   accounts_receivable = Asset.find_by_name('Accounts Receivable')
  #
  #   Transaction.create(:description => "Receiving payment on an invoice" ,
  #                      :debit_account => cash,
  #                      :credit_account => accounts_receivable,
  #                      :amount => 1000)
  #
  # @see http://en.wikipedia.org/wiki/Journal_entry Journal Entry
  #
  # @author Michael Bulat
  class Transaction < ActiveRecord::Base
    belongs_to :commercial_document, :polymorphic => true
    has_many :credit_amounts
    has_many :debit_amounts
    has_many :credit_accounts, :through => :credit_amounts, :source => :account
    has_many :debit_accounts, :through => :debit_amounts, :source => :account

    validates_presence_of :description

    validate :has_credit_amounts?
    def has_credit_amounts?
      errors[:base] << "Transaction must have at least one credit amount" if self.credit_amounts.blank?
    end

    validate :has_debit_amounts?
    def has_debit_amounts?
      errors[:base] << "Transaction must have at least one debit amount" if self.debit_amounts.blank?
    end

    validate :amounts_cancel?
    def amounts_cancel?
      errors[:base] << "The credit and debit amounts are not equal" if difference_of_amounts != 0
    end

    private
      def difference_of_amounts
        credit_amount_total = credit_amounts.inject(0) {|sum, credit_amount| sum + credit_amount.amount.to_i}
        debit_amount_total = debit_amounts.inject(0) {|sum, debit_amount| sum + debit_amount.amount.to_i}
        credit_amount_total - debit_amount_total  
      end
  end
end
