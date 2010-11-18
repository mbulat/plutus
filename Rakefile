require 'rake'
require 'yard'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "plutus"
    gem.summary = "A Plugin providing a Double Entry Accounting Engine for Rails"
    gem.email = "mbulat@crazydogsoftware.com"
    gem.homepage = ""
    gem.authors = ["Michael Bulat"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

desc 'Generate documentation for the plutus plugin.'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'app/**/*.rb']   # optional
  t.options = [] # optional
end
