class ReviewForm < ActiveRecord::Base
  belongs_to :stage, :class_name => 'ReviewStage', :foreign_key => 'review_stage_id'
  has_many :questions, :class_name => 'ReviewFormQuestion', :dependent => :destroy, :order => 'sequence ASC, created_at ASC'
end
