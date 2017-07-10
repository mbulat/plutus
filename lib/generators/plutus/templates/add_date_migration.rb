class AddDateToPlutusEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :plutus_entries, :date, :date
    add_index :plutus_entries, :date
  end
end
