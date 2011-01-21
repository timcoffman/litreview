class CreateImportMappings < ActiveRecord::Migration
  def self.up
    create_table :import_mappings do |t|
      t.references :document_source, :null => false
      t.string :column_heading, :null => false
      t.string :document_attribute

      t.timestamps
    end
  end

  def self.down
    drop_table :import_mappings
  end
end
