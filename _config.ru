# This file is used by Rack-based servers to start the application.

# Require your environment file to bootstrap Rails
require ::File.expand_path('../config/environment',  __FILE__)

# Dispatch the request
run lambda { |env|
	#ActionController::Dispatcher.new( $stdout ).dispatch()
	[ 200, { 'Content-Type'=>'text/plain'}, StringIO.new("Hello World!\n") ]
}
