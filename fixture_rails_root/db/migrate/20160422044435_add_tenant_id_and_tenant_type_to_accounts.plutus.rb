# This migration comes from plutus (originally 20160422034059)
class AddTenantIdAndTenantTypeToAccounts < ActiveRecord::Migration
  def up
    unless Plutus.enable_tenancy
      add_column :plutus_accounts, :tenant_id, :integer
    end

    add_column :plutus_accounts, :tenant_type, :string

    Plutus::Account.reset_column_information
    Plutus::Account.update_all(tenant_type: Plutus.tenant_class)

    add_index :plutus_accounts, [:tenant_id, :tenant_type]
  end

  def down
    unless Plutus.enable_tenancy
      remove_column :plutus_accounts, :tenant_id, :integer
    end
    remove_column :plutus_accounts, :tenant_type, :string
  end
end
