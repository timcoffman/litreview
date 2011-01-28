class CreateReviewFormPossibleAnswers < ActiveRecord::Migration
  def self.up
    create_table :review_form_possible_answers do |t|
      t.references :review_form_question, :null => false
      t.integer :sequence, :null => true
      t.string :possible_answer, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :review_form_possible_answers
  end
end
