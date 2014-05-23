class CreatePlutusTables < ActiveRecord::Migration
  def self.up
    create_table :plutus_commodities do |t|
      t.string :name
      t.string :iso_code
    end

    create_table :plutus_accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra
      t.references :commodity

      t.timestamps
    end
    add_index :plutus_accounts, [:name, :type]
    add_index :plutus_accounts, :commodity_id

    create_table :plutus_entries do |t|
      t.string :description
      t.integer :commercial_document_id
      t.string :commercial_document_type
      t.references :commodity

      t.timestamps
    end
    add_index :plutus_entries, [:commercial_document_id, :commercial_document_type], :name => "index_entries_on_commercial_doc"
    add_index :plutus_entries, :commodity_id

    create_table :plutus_amounts do |t|
      t.string :type
      t.references :account
      t.references :entry
      t.decimal :amount, :precision => 20, :scale => 10
      t.decimal :value, :precision => 20, :scale => 10
    end
    add_index :plutus_amounts, :type
    add_index :plutus_amounts, [:account_id, :entry_id]
    add_index :plutus_amounts, [:entry_id, :account_id]

    create_table :plutus_prices do |t|
      t.integer :commodity_one
      t.integer :commodity_two
      t.decimal :value, :precision => 20, :scale => 10

      t.datetime :created_at
    end
  end

  def self.down
    drop_table :plutus_accounts
    drop_table :plutus_entries
    drop_table :plutus_amounts
  end
end
