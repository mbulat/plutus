module Plutus
  # Association extension for has_many :amounts relations. Internal.
  module AmountsExtension
    # Returns a sum of the referenced Amount objects.
    def balance
      balance = BigDecimal.new('0')
      each do |amount_record|
        balance += amount_record.amount
      end
      return balance
    end
  end
end