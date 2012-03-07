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
      t.integer :credit_account_id
      t.integer :debit_account_id
      t.decimal :amount, :precision => 20, :scale => 10
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end

		add_index :plutus_transactions, :credit_account_id
		add_index :plutus_transactions, :debit_account_id
		add_index :plutus_transactions, [:commercial_document_id, :commercial_document_type], :name => "index_transactions_on_commercial_doc"
  end

  def self.down
    drop_table :plutus_accounts
    drop_table :plutus_transactions
  end
end
