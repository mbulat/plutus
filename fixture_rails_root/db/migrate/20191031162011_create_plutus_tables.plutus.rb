# This migration comes from plutus (originally 20160422010135)
class CreatePlutusTables < ActiveRecord::Migration[4.2]
  def change
    create_table :plutus_accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra, default: false

      t.timestamps
    end
    add_index :plutus_accounts, [:name, :type]

    create_table :plutus_entries do |t|
      t.string :description
      t.date :date
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end
    add_index :plutus_entries, :date
    add_index :plutus_entries, [:commercial_document_id, :commercial_document_type], :name => "index_entries_on_commercial_doc"

    create_table :plutus_amounts do |t|
      t.string :type
      t.references :account
      t.references :entry
      t.decimal :amount, :precision => 20, :scale => 10
    end
    add_index :plutus_amounts, :type
    add_index :plutus_amounts, [:account_id, :entry_id]
    add_index :plutus_amounts, [:entry_id, :account_id]
  end
end
