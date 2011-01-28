class AddIndexToReviewFormQuestion < ActiveRecord::Migration
  def self.up
    add_index :review_form_possible_answers, [:review_form_question_id, :sequence], :unique => true, :name => :sequence
  end

  def self.down
    remove_index :review_form_possible_answers, :name => :sequence
  end
end
