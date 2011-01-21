class AddIndexToImportMappings < ActiveRecord::Migration
  def self.up
    add_index :import_mappings, [:document_source_id, :column_heading], :unique => true, :name => :column_heading
  end

  def self.down
    remove_index :import_mappings, :name => :column_heading
  end
end
