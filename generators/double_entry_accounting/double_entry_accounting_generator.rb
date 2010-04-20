class DoubleEntryAccountingGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # m.directory "lib"
      # m.template 'README', "README"
      m.migration_template 'double_entry_accounting.rb', 'db/migrate' 
    end
  end
end
