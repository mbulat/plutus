source "http://rubygems.org"

# Specify your gem's dependencies in plutus.gemspec
gemspec

group :development, :test do
  gem 'sqlite3',      platform: [:ruby, :mswin, :mingw]
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'simplecov',    require: false
  gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3', '>= 1.3.20', platform: :jruby
  gem 'rails-controller-testing',         '~> 0.1.1'
  gem 'factory_girl_rails',               '~> 4.7'
  gem 'rspec',                            '~> 3.5'
  gem 'rspec-rails',                      '~> 3.5', '>= 3.5.1'
  gem 'shoulda-matchers',                 '~> 3.1', '>= 3.1.1'
  gem 'rspec-its',                        '~> 1.2'
  gem 'pry-rails',                        '~> 0.3.4'
  gem 'database_cleaner'
end
