class AddKeywordsToReviewStage < ActiveRecord::Migration
  def self.up
	add_column :review_stages, :keywords, :string, :null => true, :limit => 1024
  end

  def self.down
	remove_column :review_stages, :keywords
  end
end
