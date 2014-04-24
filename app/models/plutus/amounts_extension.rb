module Plutus
  # Association extension for has_many :amounts relations. Internal.
  module AmountsExtension
    # Returns a sum of the referenced Amount objects.
    def balance(direct = true)
      balanced_field = direct ? :amount : :value
      if all?(&:new_record?)
        map(&balanced_field).compact.reduce(BigDecimal.new('0'), :+)
      else
        sum(balanced_field)
      end
    end
  end
end
