class Manager < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

	def full_name
		self.user.full_name
	end
end
