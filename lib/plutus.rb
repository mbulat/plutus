# Plutus
require "rails"
require "protected_attributes"
module Plutus
  class Engine < Rails::Engine
    isolate_namespace Plutus
  end
end
