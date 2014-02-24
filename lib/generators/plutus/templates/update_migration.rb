class UpdatePlutusTables < ActiveRecord::Migration
  def change
    # we have to remove these indexes because the temporary
    # table index name is too long
    remove_index :plutus_amounts, [:account_id, :transaction_id]
    remove_index :plutus_amounts, [:transaction_id, :account_id]
    
    rename_table :plutus_transactions, :plutus_entries
    rename_column :plutus_amounts, :transaction_id, :entry_id
    
    # adding the indexes back
    add_index :plutus_amounts, [:account_id, :entry_id]
    add_index :plutus_amounts, [:entry_id, :account_id]
  end
end
