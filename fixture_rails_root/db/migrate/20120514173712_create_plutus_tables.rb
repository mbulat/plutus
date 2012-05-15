class CreatePlutusTables < ActiveRecord::Migration
  def self.up
    create_table :plutus_accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra

      t.timestamps
    end
    add_index :plutus_accounts, [:name, :type]

    create_table :plutus_transactions do |t|
      t.string :description
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end
    add_index :plutus_transactions, [:commercial_document_id, :commercial_document_type], :name => "index_transactions_on_commercial_doc"

    create_table :plutus_amounts do |t|
      t.string :type
      t.references :account
      t.references :transaction
      t.decimal :amount, :precision => 20, :scale => 10
    end 
    add_index :plutus_amounts, :type
    add_index :plutus_amounts, [:account_id, :transaction_id]
    add_index :plutus_amounts, [:transaction_id, :account_id]
  end

  def self.down
    drop_table :plutus_accounts
    drop_table :plutus_transactions
    drop_table :plutus_amounts
  end
end
