class CreateReviewForms < ActiveRecord::Migration
  def self.up
    create_table :review_forms do |t|
      t.references :review_stage, :null => false
      t.text :notes, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :review_forms
  end
end
