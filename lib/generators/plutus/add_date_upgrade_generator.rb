require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Plutus
  class AddDateUpgradeGenerator < BaseGenerator
    def create_migration_file
      migration_template 'add_date_migration.rb', 'db/migrate/add_date_to_plutus_entries.rb'
    end
  end
end
