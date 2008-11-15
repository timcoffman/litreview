class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :document_source_id
      t.string :pub_ident
      t.string :title
      t.string :authors
      t.string :journal
      t.string :when_published
      t.text :abstract
      t.integer :duplicate_of_document_id

      t.timestamps
    end
    add_index :pub_ident, :unique => true
  end

  def self.down
    drop_table :documents
  end
end
