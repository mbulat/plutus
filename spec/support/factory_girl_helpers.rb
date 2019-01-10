module FactoryBotHelpers
  def self.reload
    FactoryBot.factories.clear()
    FactoryBot.sequences.clear()
    FactoryBot.traits.clear()
    FactoryBot.find_definitions()
  end
end
