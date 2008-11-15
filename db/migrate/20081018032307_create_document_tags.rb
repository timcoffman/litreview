class CreateDocumentTags < ActiveRecord::Migration
  def self.up
    create_table :document_tags do |t|
      t.integer :tag_id
      t.integer :document_id
	  t.integer :applied_by_user_id
	  t.integer :applied_in_review_stage_id

      t.timestamps
    end
  end

  def self.down
    drop_table :document_tags
  end
end
