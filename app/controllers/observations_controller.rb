class ObservationsController < ApplicationController

before_filter :require_login

def create
	@observation = Observation.new( params[:observation] )
	if @observation.save
		render :partial => 'show', :locals => { :observation => @observation }
	else
		render :partial => 'error', :locals => { :observation => @observation }
	end
end

end

