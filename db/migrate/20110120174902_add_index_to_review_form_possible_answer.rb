class AddIndexToReviewFormPossibleAnswer < ActiveRecord::Migration
  def self.up
    add_index :review_form_questions, [:review_form_id, :sequence], :unique => true, :name => :rf_q_sequence
  end

  def self.down
    remove_index :review_form_questions, :name => :rf_q_sequence
  end
end
