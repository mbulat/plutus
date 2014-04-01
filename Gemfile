source "http://rubygems.org"

# Specify your gem's dependencies in valkyrie.gemspec
gemspec

group :development, :test do
  gem "sqlite3", :platform => [:ruby, :mswin, :mingw]
  gem "jdbc-sqlite3", :platform => :jruby
  gem 'activerecord-jdbcsqlite3-adapter', :require => 'jdbc-sqlite3', :require =>'arjdbc', :platform => :jruby
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
