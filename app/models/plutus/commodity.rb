module Plutus
  class Commodity < ActiveRecord::Base

    has_one :trading_account, class_name: 'Plutus::Trading', foreign_key: 'commodity_id'

    attr_accessor :currency

    delegate :iso_numeric, :symbol, :subunit, :subunit_to_unit, :separator,
      :delimiter, to: :currency, allow_nil: true

    after_initialize do
      self.currency = Money::Currency.find(self.iso_code)
      self.name ||= currency.try(:name)
    end

    def self.exchange(amount, from, to)
      amount * Plutus::Price.get_last(from, to).value
    end

    def exchange(amount, to)
      self.class.exchange(amount, self, to)
    end

    after_create do
      create_trading_account!(name: "#{iso_code || name} Trading")
    end

  end
end
