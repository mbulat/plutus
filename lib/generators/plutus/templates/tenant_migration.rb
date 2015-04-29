class TenantPlutusTables < ActiveRecord::Migration
  def change
    # add a tenant column to plutus accounts table.
    add_column :plutus_accounts, :"#{Plutus.tenant_attribute_name}_id", :integer, index: true
  end
end
