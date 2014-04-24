module Plutus
  class Price < ActiveRecord::Base
    belongs_to :commodity_one, class_name: 'Plutus::Commodity', foreign_key: 'commodity_one'
    belongs_to :commodity_two, class_name: 'Plutus::Commodity', foreign_key: 'commodity_two'

    def self.get_last commodity_one, commodity_two
      latest = where(nil).order("created_at DESC").find_or_initialize_by(
        commodity_one: commodity_one, commodity_two: commodity_two
      )

      return latest if latest.persisted?

      currency_from = commodity_one.currency.to_s
      currency_to = commodity_two.currency.to_s
      exchange_rate = Money.new(100, currency_from).exchange_to(currency_to).amount
      latest.value = exchange_rate
      latest.save!
      latest
    end
  end
end
