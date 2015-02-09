module Plutus
  # Association extension for has_many :amounts relations. Internal.
  module AmountsExtension
    # Returns a sum of the referenced Amount objects.
    def balance
      owner = @association.instance_variable_get("@owner")
      currency = owner.try(:currency) || first.currency

      if owner.try(:persisted?)
        Money.new(sum(:amount_cents), currency)
      else
        reduce(0.to_money(currency)) do |sum, amount_record|
          sum + (amount_record.amount || 0.to_money(currency))
        end
      end
    end
  end
end
