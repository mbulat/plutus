source "http://rubygems.org"

# Specify your gem's dependencies in plutus.gemspec
gemspec

group :development, :test do
  gem "sqlite3", :platform => [:ruby, :mswin, :mingw]
  gem "jdbc-sqlite3", :platform => :jruby
  gem 'activerecord-jdbcsqlite3-adapter', :require => 'jdbc-sqlite3', :platform => :jruby
  gem 'factory_bot_rails', "~> 4.8.2"
  gem 'rspec', "~> 3"
  gem 'rspec-rails', "~> 3"
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'coveralls', require: false
end
group :test do
  gem 'shoulda-matchers', '4.0.0.rc1'
end
