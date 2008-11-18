class Inviter < ActionMailer::Base

def invitation( user, project, address )
	recipients address
	from "<a href='mailto:#{user.email}'>#{user.full_name}</a>"
	subject "Invitation to Join a Literature Review Project: #{project.title}"
	body :user => user, :project => project
end

end
