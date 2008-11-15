class CreateDocumentReviewReasons < ActiveRecord::Migration
  def self.up
    create_table :document_review_reasons do |t|
      t.integer :document_review_id
      t.integer :reason_id

      t.timestamps
    end
  end

  def self.down
    drop_table :document_review_reasons
  end
end
