class Observation < ActiveRecord::Base


validates_presence_of :description, :location


end
