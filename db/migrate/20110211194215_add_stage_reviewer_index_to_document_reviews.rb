class AddStageReviewerIndexToDocumentReviews < ActiveRecord::Migration
  def self.up
	add_index :document_reviews, [ :stage_reviewer_id ], :unique => false, :name => 'stage_reviewer'
  end

  def self.down
	remove_index :document_reviews, :name => 'stage_reviewer'
  end
end
