class CreateStageReviewers < ActiveRecord::Migration
  def self.up
    create_table :stage_reviewers do |t|
      t.integer :review_stage_id
      t.integer :user_id
	
      t.timestamps
    end
  end

  def self.down
    drop_table :stage_reviewers
  end
end
