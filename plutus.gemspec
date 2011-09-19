# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{plutus}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bulat"]
  s.date = %q{2010-12-03}
  s.description = %q{The plutus plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general Double Entry Bookkeeping practices. All calculations are done using BigDecimal in order to prevent floating point rounding errors. The plugin requires a decimal type on your database as well.}
  s.email = %q{mbulat@crazydogsoftware.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.add_dependency("rails", ">= 3.0")
  s.add_development_dependency("sqlite3")
  s.add_development_dependency("rspec", "~> 2.6")
  s.add_development_dependency("rspec-rails", "~> 2.6")
  s.add_development_dependency("rspec-rails", "~> 2.6")
  s.add_development_dependency("factory_girl")
  s.add_development_dependency("factory_girl_rails", "~> 1.1")
  s.files = [
    ".yardopts",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION.yml",
    "app/controllers/accounts_controller.rb",
    "app/controllers/transactions_controller.rb",
    "app/models/account.rb",
    "app/models/asset.rb",
    "app/models/equity.rb",
    "app/models/expense.rb",
    "app/models/liability.rb",
    "app/models/revenue.rb",
    "app/models/transaction.rb",
    "app/views/accounts/index.html.erb",
    "app/views/accounts/show.html.erb",
    "app/views/layouts/accounts.html.erb",
    "app/views/layouts/transactions.html.erb",
    "app/views/transactions/index.html.erb",
    "app/views/transactions/show.html.erb",
    "config/backtrace_silencers.rb",
    "config/inflections.rb",
    "config/mime_types.rb",
    "config/secret_token.rb",
    "config/session_store.rb",
    "doc/Account.html",
    "doc/AccountsController.html",
    "doc/Asset.html",
    "doc/CreatePlutusTables.html",
    "doc/Equity.html",
    "doc/Expense.html",
    "doc/Liability.html",
    "doc/Plutus.html",
    "doc/Plutus/Engine.html",
    "doc/PlutusGenerator.html",
    "doc/Revenue.html",
    "doc/Transaction.html",
    "doc/TransactionsController.html",
    "doc/_index.html",
    "doc/class_list.html",
    "doc/css/common.css",
    "doc/css/full_list.css",
    "doc/css/style.css",
    "doc/file.README.html",
    "doc/file_list.html",
    "doc/frames.html",
    "doc/index.html",
    "doc/js/app.js",
    "doc/js/full_list.js",
    "doc/js/jquery.js",
    "doc/method_list.html",
    "doc/top-level-namespace.html",
    "fixture_rails_root/.gitignore",
    "fixture_rails_root/Gemfile",
    "fixture_rails_root/Gemfile.lock",
    "fixture_rails_root/README",
    "fixture_rails_root/Rakefile",
    "fixture_rails_root/app/controllers/application_controller.rb",
    "fixture_rails_root/app/helpers/application_helper.rb",
    "fixture_rails_root/app/views/layouts/application.html.erb",
    "fixture_rails_root/config.ru",
    "fixture_rails_root/config/application.rb",
    "fixture_rails_root/config/boot.rb",
    "fixture_rails_root/config/database.yml",
    "fixture_rails_root/config/environment.rb",
    "fixture_rails_root/config/environments/development.rb",
    "fixture_rails_root/config/environments/production.rb",
    "fixture_rails_root/config/environments/test.rb",
    "fixture_rails_root/config/initializers/backtrace_silencers.rb",
    "fixture_rails_root/config/initializers/inflections.rb",
    "fixture_rails_root/config/initializers/mime_types.rb",
    "fixture_rails_root/config/initializers/secret_token.rb",
    "fixture_rails_root/config/initializers/session_store.rb",
    "fixture_rails_root/config/locales/en.yml",
    "fixture_rails_root/config/routes.rb",
    "fixture_rails_root/db/migrate/20101203193439_create_plutus_tables.rb",
    "fixture_rails_root/db/schema.rb",
    "fixture_rails_root/db/seeds.rb",
    "fixture_rails_root/doc/README_FOR_APP",
    "fixture_rails_root/lib/tasks/.gitkeep",
    "fixture_rails_root/public/404.html",
    "fixture_rails_root/public/422.html",
    "fixture_rails_root/public/500.html",
    "fixture_rails_root/public/favicon.ico",
    "fixture_rails_root/public/images/rails.png",
    "fixture_rails_root/public/index.html",
    "fixture_rails_root/public/javascripts/application.js",
    "fixture_rails_root/public/javascripts/controls.js",
    "fixture_rails_root/public/javascripts/dragdrop.js",
    "fixture_rails_root/public/javascripts/effects.js",
    "fixture_rails_root/public/javascripts/prototype.js",
    "fixture_rails_root/public/javascripts/rails.js",
    "fixture_rails_root/public/robots.txt",
    "fixture_rails_root/public/stylesheets/.gitkeep",
    "fixture_rails_root/script/rails",
    "fixture_rails_root/test/performance/browsing_test.rb",
    "fixture_rails_root/test/test_helper.rb",
    "fixture_rails_root/vendor/plugins/.gitkeep",
    "lib/generators/plutus/USAGE",
    "lib/generators/plutus/plutus_generator.rb",
    "lib/generators/plutus/templates/migration.rb",
    "lib/plutus.rb",
    "plutus.gemspec",
    "spec/controllers/accounts_controller_spec.rb",
    "spec/controllers/transactions_controller_spec.rb",
    "spec/factories/account_factory.rb",
    "spec/factories/transaction_factory.rb",
    "spec/lib/plutus_spec.rb",
    "spec/models/account_spec.rb",
    "spec/models/asset_spec.rb",
    "spec/models/equity_spec.rb",
    "spec/models/expense_spec.rb",
    "spec/models/liability_spec.rb",
    "spec/models/revenue_spec.rb",
    "spec/models/transaction_spec.rb",
    "spec/rcov.opts",
    "spec/routing/accounts_routing_spec.rb",
    "spec/routing/transactions_routing_spec.rb",
    "spec/schema.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "tasks/plutus_tasks.rake"
  ]
  s.homepage = %q{http://github.com/mbulat/Plutus}
  s.require_paths = ["lib"]
  s.required_rubygems_version = ">= 1.3.6"
  s.summary = %q{A Plugin providing a Double Entry Accounting Engine for Rails}
  s.test_files = [
    "spec/controllers/accounts_controller_spec.rb",
    "spec/controllers/transactions_controller_spec.rb",
    "spec/factories/account_factory.rb",
    "spec/factories/transaction_factory.rb",
    "spec/lib/plutus_spec.rb",
    "spec/models/account_spec.rb",
    "spec/models/asset_spec.rb",
    "spec/models/equity_spec.rb",
    "spec/models/expense_spec.rb",
    "spec/models/liability_spec.rb",
    "spec/models/revenue_spec.rb",
    "spec/models/transaction_spec.rb",
    "spec/routing/accounts_routing_spec.rb",
    "spec/routing/transactions_routing_spec.rb",
    "spec/schema.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

