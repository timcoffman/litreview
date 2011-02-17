class AddDocumentIndexToDocumentReviews < ActiveRecord::Migration
  def self.up
	add_index :document_reviews, [ :document_id ], :unique => false, :name => 'document'
  end

  def self.down
	remove_index :document_reviews, :name => 'document'
  end
end
