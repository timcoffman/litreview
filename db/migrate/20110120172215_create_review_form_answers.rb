class CreateReviewFormAnswers < ActiveRecord::Migration
  def self.up
    create_table :review_form_answers do |t|
      t.references :document_review, :null => false
      t.references :review_form_question, :null => false
      t.references :review_form_possible_answer, :null => true
      t.string :impromptu_answer, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :review_form_answers
  end
end
