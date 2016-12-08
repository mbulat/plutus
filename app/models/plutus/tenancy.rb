module Plutus
  module Tenancy
    extend ActiveSupport::Concern

    included do
      validates :name, presence: true, uniqueness: { scope: :"#{Plutus.tenant_attribute_name}_id" }

      belongs_to Plutus.tenant_attribute_name.to_sym, class_name: Plutus.tenant_class
    end
  end
end
