source "http://rubygems.org"

# Specify your gem's dependencies in plutus.gemspec
gemspec

group :development, :test do
  gem "sqlite3", :platform => [:ruby, :mswin, :mingw]
  gem "jdbc-sqlite3", :platform => :jruby
  gem 'activerecord-jdbcsqlite3-adapter', :require => 'jdbc-sqlite3', :platform => :jruby
  gem 'factory_girl_rails', "~> 1.1"
  gem 'rspec', "~> 3", "< 6.2"
  gem 'rspec-rails', "~> 3",  "< 6.2"
  gem 'rails-controller-testing', "< 6.2"
  gem 'rspec-its'
  gem 'coveralls', require: false
end
