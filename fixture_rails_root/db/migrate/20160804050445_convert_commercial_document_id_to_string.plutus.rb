# This migration comes from plutus (originally 20160804045957)
class ConvertCommercialDocumentIdToString < ActiveRecord::Migration
  def change
    change_column :plutus_entries, :commercial_document_id, :string
  end
end
