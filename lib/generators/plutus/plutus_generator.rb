# lib/generators/plutus/plutus_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Plutus
  class PlutusGenerator < BaseGenerator
    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_plutus_tables.rb'
    end
  end
end
