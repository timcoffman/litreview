class ReviewFormQuestion < ActiveRecord::Base
   belongs_to :form, :class_name => 'ReviewForm', :foreign_key => 'review_form_id'
   has_many :possible_answers, :class_name => 'ReviewFormPossibleAnswer', :dependent => :destroy, :order => 'sequence ASC, created_at ASC'
   has_many :answers, :class_name => 'ReviewFormAnswer', :dependent => :destroy

   before_validation_on_create :assign_defaults
   
   validate :answerable?
   validates_inclusion_of :answer_type, :in => %w( yes_no yes_no_maybe short long any_possible one_possible )
   
   def answerable?
     self.allow_impromptu_answer ||
     !self.possible_answers.empty?
   end
   private :answerable?
   
   def assign_defaults
     self.sequence ||= (ReviewFormQuestion.maximum(:sequence,:conditions => { :review_form_id => self.review_form_id} ) || 0) + 1
     self.question ||= 'new question'
     self.answer_type ||= 'yes_no'
     self.allow_impromptu_answer = false if self.allow_impromptu_answer.nil?
     true
   end
   private :assign_defaults
end
