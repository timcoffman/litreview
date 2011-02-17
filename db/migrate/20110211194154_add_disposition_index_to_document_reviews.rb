class AddDispositionIndexToDocumentReviews < ActiveRecord::Migration
  def self.up
	add_index :document_reviews, [ :disposition ], :unique => false, :name => 'disposition'
  end

  def self.down
	remove_index :document_reviews, :name => 'disposition'
  end
end
