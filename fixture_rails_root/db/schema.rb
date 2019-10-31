# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191031170618) do

  create_table "plutus_accounts", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "contra", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tenant_id"
    t.index ["name", "type"], name: "index_plutus_accounts_on_name_and_type"
  end

  create_table "plutus_amounts", force: :cascade do |t|
    t.string "type"
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount", precision: 20, scale: 10
    t.index ["account_id", "entry_id"], name: "index_plutus_amounts_on_account_id_and_entry_id"
    t.index ["entry_id", "account_id"], name: "index_plutus_amounts_on_entry_id_and_account_id"
    t.index ["type"], name: "index_plutus_amounts_on_type"
  end

  create_table "plutus_entries", force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.integer "commercial_document_id"
    t.string "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commercial_document_id", "commercial_document_type"], name: "index_entries_on_commercial_doc"
    t.index ["date"], name: "index_plutus_entries_on_date"
  end

end
