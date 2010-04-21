class DoubleEntryAccounting < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra

      t.timestamps
    end
    
    create_table :transactions do |t|
      t.string :description
      t.integer :credit_account_id
      t.integer :debit_account_id
      t.decimal :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
    drop_table :transactions
  end
end