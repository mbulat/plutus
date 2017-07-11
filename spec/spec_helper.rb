require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.dirname(__FILE__) + "/../fixture_rails_root/config/environment")

require Rails.root.join('db/schema').to_s
require 'rspec/rails'

$: << File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'plutus'
require 'kaminari'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require 'factory_girl'
plutus_definitions = File.expand_path(File.join(File.dirname(__FILE__), 'factories'))
FactoryGirl.definition_file_paths << plutus_definitions


RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

FactoryGirlHelpers.reload()
