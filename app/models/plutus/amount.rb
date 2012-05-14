module Plutus
  class Amount < ActiveRecord::Base
    belongs_to :transaction
    belongs_to :account

    validates_presence_of :type, :amount, :transaction, :account
  end
end