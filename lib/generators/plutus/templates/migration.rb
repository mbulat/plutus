class CreatePlutusTables < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra

      t.timestamps
    end
    
		add_index :accounts, [:name, :type]
   
    create_table :transactions do |t|
      t.string :description
      t.integer :credit_account_id
      t.integer :debit_account_id
      t.decimal :amount, :precision => 20, :scale => 10
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end

		add_index :transactions, :credit_account_id
		add_index :transactions, :debit_account_id
		add_index :transactions, [:commercial_document_id, :commercial_document_type], :name => "index_transactions_on_commercial_doc"
  end

  def self.down
    drop_table :accounts
    drop_table :transactions
  end
end
