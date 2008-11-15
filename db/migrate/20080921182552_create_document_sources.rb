class CreateDocumentSources < ActiveRecord::Migration
  def self.up
    create_table :document_sources do |t|
      t.integer :project_id
      t.string :name
      t.string :identifier
      t.string :website
      t.string :query_url_template

      t.timestamps
    end
  end

  def self.down
    drop_table :document_sources
  end
end
