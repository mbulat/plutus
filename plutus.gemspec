# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{plutus}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bulat"]
  s.date = %q{2011-03-31}
  s.description = %q{The plutus plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general Double Entry Bookkeeping practices. All calculations are done using BigDecimal in order to prevent floating point rounding errors. The plugin requires a decimal type on your database as well.}
  s.email = %q{mbulat@crazydogsoftware.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.add_dependency("rails", "~> 3.1")
  s.add_development_dependency("sqlite3")
  s.add_development_dependency("rspec", "~> 2.6")
  s.add_development_dependency("rspec-rails", "~> 2.6")
  s.add_development_dependency("rspec-rails", "~> 2.6")
  s.add_development_dependency("factory_girl")
  s.add_development_dependency("factory_girl_rails", "~> 1.1")
  s.files = [
    ".gitignore",
    ".travis.yml",
    ".yardopts",
    "Gemfile",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION.yml",
    "app/controllers/plutus/accounts_controller.rb",
    "app/controllers/plutus/transactions_controller.rb",
    "app/models/plutus/account.rb",
    "app/models/plutus/asset.rb",
    "app/models/plutus/equity.rb",
    "app/models/plutus/expense.rb",
    "app/models/plutus/liability.rb",
    "app/models/plutus/revenue.rb",
    "app/models/plutus/transaction.rb",
    "app/views/plutus/accounts/index.html.erb",
    "app/views/plutus/accounts/show.html.erb",
    "app/views/plutus/layouts/accounts.html.erb",
    "app/views/plutus/layouts/transactions.html.erb",
    "app/views/plutus/transactions/index.html.erb",
    "app/views/plutus/transactions/show.html.erb",
    "config/backtrace_silencers.rb",
    "config/database.yml",
    "config/inflections.rb",
    "config/mime_types.rb",
    "config/secret_token.rb",
    "config/session_store.rb",
    "doc/Plutus.html",
    "doc/Plutus/Account.html",
    "doc/Plutus/AccountsController.html",
    "doc/Plutus/Asset.html",
    "doc/Plutus/Equity.html",
    "doc/Plutus/Expense.html",
    "doc/Plutus/Liability.html",
    "doc/Plutus/Revenue.html",
    "doc/Plutus/Transaction.html",
    "doc/Plutus/TransactionsController.html",
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
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

