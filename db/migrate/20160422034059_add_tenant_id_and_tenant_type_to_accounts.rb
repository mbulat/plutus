class AddTenantIdAndTenantTypeToAccounts < ActiveRecord::Migration
  def up
    if Plutus.enable_tenancy
      rename_column :plutus_accounts, :tenant_id, :old_tenant_id
      Plutus::Account.reset_column_information
    end

    add_column :plutus_accounts, :tenant_id, :string
    add_column :plutus_accounts, :tenant_type, :string

    Plutus::Account.update_all(tenant_type: Plutus.tenant_class)

    if Plutus.enable_tenancy
      Plutus::Account.find_each do |account|
        account.update(tenant_id: account.old_tenant_id.to_s)
      end
      remove_column :plutus_accounts, :old_tenant_id
    end

    add_index :plutus_accounts, [:tenant_id, :tenant_type]
  end

  def down
    if Plutus.enable_tenancy
      rename_column :plutus_accounts, :tenant_id, :new_tenant_id
      Plutus::Account.reset_column_information
      add_column :plutus_accounts, :tenant_id, :integer, index: true

      Plutus::Account.find_each do |account|
        account.update(tenant_id: account.new_tenant_id.to_i)
      end

      remove_column :plutus_accounts, :new_tenant_id
    else
      remove_column :plutus_accounts, :tenant_id, :string
    end
    remove_column :plutus_accounts, :tenant_type, :string
  end
end
