module Plutus
  module Tenancy
    extend ActiveSupport::Concern

    included do
      validates :name, presence: true, uniqueness: { scope: :tenant_id }

      belongs_to :tenant, class_name: Plutus.tenant_class
    end
  end
end
