module Plutus
  # The Amount class represents debit and credit amounts in the system.
  #
  # @abstract
  #   An amount must be a subclass as either a debit or a credit to be saved to the database.
  #
  # @author Michael Bulat
  class Amount < ActiveRecord::Base
    belongs_to :entry, :class_name => 'Plutus::Entry'
    belongs_to :account, :class_name => 'Plutus::Account'

    validates_presence_of :type, :amount, :entry, :account
    # attr_accessible :account, :account_name, :amount, :entry

    delegate :name, to: :account, prefix: true, allow_nil: true

    # Assign an account by name
    def account_name=(name)
      self.account = Account.find_by_name!(name)
    end

    protected
  end
end
