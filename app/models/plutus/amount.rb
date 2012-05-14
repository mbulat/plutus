module Plutus
  # The Amount class represents debit and credit amounts in the system.
  #
  # @abstract
  #   An amount must be a subclass as either a debit or a credit to be saved to the database. 
  #
  # @author Michael Bulat
  class Amount < ActiveRecord::Base
    belongs_to :transaction
    belongs_to :account

    validates_presence_of :type, :amount, :transaction, :account
  end
end