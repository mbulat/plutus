module Plutus
  module Tenancy
    extend ActiveSupport::Concern

    included do
      validates :name, presence: true
      validate :is_name_unique?

      belongs_to :tenant, class_name: Plutus.tenant_class

      private
        def is_name_unique?
          if Plutus::Asset.exists?(name: name, tenant_id: tenant_id)
            errors.add(:name, "has already been taken")
          end
        end
    end
  end
end
