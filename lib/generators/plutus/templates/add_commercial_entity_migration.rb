class AddCommercialEntityToPlutusAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :plutus_accounts, :commercial_entity_id, :integer
    add_column :plutus_accounts, :commercial_entity_type, :string
    add_index :plutus_accounts, [:commercial_entity_type, :commercial_entity_id], :name => "index_accounts_on_commercial_entity"
  end
end
