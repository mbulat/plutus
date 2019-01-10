require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Plutus
  class AddCommercialEntityUpgradeGenerator < BaseGenerator
    def create_migration_file
      migration_template 'add_commercial_entity_migration.rb', 'db/migrate/add_commercial_entity_to_plutus_accounts.rb'
    end
  end
end
