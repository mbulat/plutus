class TenantPlutusTables < ActiveRecord::Migration[4.2]
  def change
    # add a tenant column to plutus accounts table.
    add_column :plutus_accounts, :tenant_id, :integer, index: true
  end
end
