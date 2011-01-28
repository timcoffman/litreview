class ReviewFormPossibleAnswer < ActiveRecord::Base
  belongs_to :question, :class_name => 'ReviewFormQuestion', :foreign_key => 'review_form_question_id'
  has_many :answers, :class_name => 'ReviewFormAnswer', :dependent => :destroy
end
