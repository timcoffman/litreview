class CreateDocumentReviews < ActiveRecord::Migration
  def self.up
    create_table :document_reviews do |t|
      t.integer :document_id
      t.integer :stage_reviewer_id
      t.integer :reviewer_sequence, :default => 0
      t.integer :reviewer_snooze, :default => 0
      t.string :disposition
      t.datetime :when_reviewed

      t.timestamps
    end
  end

  def self.down
    drop_table :document_reviews
  end
end
