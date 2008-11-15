class DocumentTag < ActiveRecord::Base
	belongs_to :document
	belongs_to :tag
	belongs_to :user, :class_name => 'User', :foreign_key => :applied_by_user_id
	belongs_to :stage, :class_name => 'ReviewStage', :foreign_key => :applied_in_review_stage_id
end
