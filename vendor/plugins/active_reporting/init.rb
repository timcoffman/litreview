require 'active_reporting'

config.to_prepare do
  ActiveRecord::Base.send :include, ActiveReporting
end
