source "http://rubygems.org"

# Specify your gem's dependencies in plutus.gemspec
gemspec

group :development, :test do
  gem 'sqlite3',      platform: [:ruby, :mswin, :mingw]
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'simplecov',    require: false
  gem 'activerecord-jdbcsqlite3-adapter', require: 'jdbc-sqlite3', require: 'arjdbc', platform: :jruby
  gem 'factory_girl_rails', '~> 4.7'
  gem 'rspec',              '~> 3.5'
  gem 'rspec-rails',        '~> 3.5', '>= 3.5.1'
  gem 'rspec-its'
end
