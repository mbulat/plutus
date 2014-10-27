module Plutus
  module NoTenancy
    extend ActiveSupport::Concern

    included do
      validates :name, presence: true, uniqueness: true
    end
  end
end
