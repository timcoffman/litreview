class CreateReviewFormQuestions < ActiveRecord::Migration
  def self.up
    create_table :review_form_questions do |t|
      t.references :review_form, :null => false
      t.integer :sequence, :null => true
      t.string :question, :null => false
      t.string :answer_type, :null => false
      t.boolean :allow_impromptu_answer, :null => false
      t.text :notes, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :review_form_questions
  end
end
