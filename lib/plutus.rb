# Plutus
require "rails"
require "money"
require "money/bank/google_currency"

Money.default_bank = Money::Bank::GoogleCurrency.new

module Plutus
  class Engine < Rails::Engine
    isolate_namespace Plutus
  end
end
