# Plutus
require "rails"

module Plutus
  class Engine < Rails::Engine
    isolate_namespace Plutus
  end


  # ------------------------------ tenancy ------------------------------
  # configuration to enable or disable tenancy
  mattr_accessor :enable_tenancy
  mattr_accessor :tenant_class
  mattr_accessor :tenant_attribute_name

  # set defaults
  self.enable_tenancy = false
  self.tenant_attribute_name = 'tenant'

  # provide hook to configure attributes
  def self.config
    yield(self)
  end
end
