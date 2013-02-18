module Plutus
  # Association extension for has_many :amounts relations. Internal.
  module AmountsExtension
    # Returns a sum of the referenced Amount objects.
    def balance
      balance = BigDecimal.new('0')
      each do |amount_record|
        if amount_record.amount
          balance += amount_record.amount
        else
          balance = nil
        end
      end
      return balance
    end
  end
end