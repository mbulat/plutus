# lib/generators/plutus/plutus_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Plutus
  class UpgradePlutusGenerator < BaseGenerator
    def create_migration_file
      migration_template 'update_migration.rb', 'db/migrate/update_plutus_tables.rb'
    end
  end
end
