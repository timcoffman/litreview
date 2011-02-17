class AddDocumentStageReviewerIndexToDocumentReviews < ActiveRecord::Migration
  def self.up
	add_index :document_reviews, [ :document_id, :stage_reviewer_id ], :unique => true, :name => 'document_and_stage_reviewer'
  end

  def self.down
	remove_index :document_reviews, :name => 'document_and_stage_reviewer'
  end
end
