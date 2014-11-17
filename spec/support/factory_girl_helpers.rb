module FactoryGirlHelpers
  def self.reload
    FactoryGirl.factories.clear()
    FactoryGirl.sequences.clear()
    FactoryGirl.traits.clear()
    FactoryGirl.find_definitions()
  end
end
