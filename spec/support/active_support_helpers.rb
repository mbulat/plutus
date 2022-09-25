module ActiveSupportHelpers
  def self.reload_model(model_name)
    Plutus.send(:remove_const, "#{model_name}")
    load("app/models/plutus/#{model_name.downcase}.rb")
  end
end
