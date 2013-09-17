# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "plutus/version"
require "date"

Gem::Specification.new do |s|
  s.name = %q{plutus}
  s.version = Plutus::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bulat"]
  s.date = Date.today
  s.description = %q{The plutus plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general Double Entry Bookkeeping practices. All calculations are done using BigDecimal in order to prevent floating point rounding errors. The plugin requires a decimal type on your database as well.}
  s.email = %q{mbulat@crazydogsoftware.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.add_dependency("rails", ">= 3.1", '< 4.1')
  s.add_development_dependency("sqlite3")
  s.add_development_dependency("rspec", "~> 2.6")
  s.add_development_dependency("rspec-rails", "~> 2.6")
  s.add_development_dependency("rspec-rails", "~> 2.6")
  s.add_development_dependency("factory_girl")
  s.add_development_dependency("factory_girl_rails", "~> 1.1")
  s.add_development_dependency("yard")
  s.add_development_dependency("redcarpet")
  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.markdown"]
  s.homepage = %q{http://github.com/mbulat/plutus}
  s.require_paths = ["lib"]
  s.required_rubygems_version = ">= 1.3.6"
  s.summary = %q{A Plugin providing a Double Entry Accounting Engine for Rails}
  s.test_files = Dir["{spec}/**/*"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

