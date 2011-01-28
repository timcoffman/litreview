class ReviewFormAnswer < ActiveRecord::Base
  belongs_to :review, :class_name => 'DocumentReview', :foreign_key => 'document_review_id'
  belongs_to :question, :class_name => 'ReviewFormQuestion', :foreign_key => 'review_form_question_id'
  belongs_to :possible_answer, :class_name => 'ReviewFormPossibleAnswer', :foreign_key => 'review_form_possible_answer_id'
  
  validate :valid_answer?
  
  def valid_answer?
    !self.possible_answer.blank? ||
    ( !self.impromptu_answer.blank? && self.question.allow_impromptu_answer )
  end
  private :valid_answer?
end
