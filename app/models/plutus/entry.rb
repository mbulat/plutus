module Plutus
  # Entries are the recording of debits and credits to various accounts.
  # This table can be thought of as a traditional accounting Journal.
  #
  # Posting to a Ledger can be considered to happen automatically, since
  # Accounts have the reverse 'has_many' relationship to either it's credit or
  # debit entries
  #
  # @example
  #   cash = Plutus::Asset.find_by_name('Cash')
  #   accounts_receivable = Plutus::Asset.find_by_name('Accounts Receivable')
  #
  #   debit_amount = Plutus::DebitAmount.new(:account => cash, :amount => 1000)
  #   credit_amount = Plutus::CreditAmount.new(:account => accounts_receivable, :amount => 1000)
  #
  #   entry = Plutus::Entry.new(:description => "Receiving payment on an invoice")
  #   entry.debit_amounts << debit_amount
  #   entry.credit_amounts << credit_amount
  #   entry.save
  #
  # @see http://en.wikipedia.org/wiki/Journal_entry Journal Entry
  #
  # @author Michael Bulat
  class Entry < ActiveRecord::Base
    before_save :default_date

    if ActiveRecord::VERSION::MAJOR > 4
      belongs_to :commercial_document, polymorphic: true, optional: true
    else
      belongs_to :commercial_document, polymorphic: true
    end

    has_many :credit_amounts, extend: AmountsExtension, class_name: 'Plutus::CreditAmount', inverse_of: :entry
    has_many :debit_amounts, extend: AmountsExtension, class_name: 'Plutus::DebitAmount', inverse_of: :entry
    has_many :credit_accounts, through: :credit_amounts, source: :account, class_name: 'Plutus::Account'
    has_many :debit_accounts, through: :debit_amounts, source: :account, class_name: 'Plutus::Account'

    validates_presence_of :description
    validate :credit_amounts?
    validate :debit_amounts?
    validate :amounts_cancel?

    # Support construction using 'credits' and 'debits' keys
    accepts_nested_attributes_for :credit_amounts, :debit_amounts, allow_destroy: true
    alias credits= credit_amounts_attributes=
    alias debits= debit_amounts_attributes=
    # attr_accessible :credits, :debits

    def default_date
      todays_date = ActiveRecord.default_timezone == :utc ? Time.now.utc : Time.now
      self.date ||= todays_date
    end
  
    # Support the deprecated .build method
    def self.build(hash)
      ActiveSupport::Deprecation.warn('Plutus::Transaction.build() is deprecated (use new instead)', caller)
      new(hash)
    end

    private 

    def credit_amounts?
      errors.add(:base, 'Entry must have at least one credit amount') if credit_amounts.blank?
    end

    def debit_amounts?
      errors.add(:base, 'Entry must have at least one debit amount') if debit_amounts.blank?
    end

    def amounts_cancel?
      if credit_amounts.balance_for_new_record != debit_amounts.balance_for_new_record
        errors.add(:base, 'The credit and debit amounts are not equal')
      end
    end
  end
end
