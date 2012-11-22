$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'lib/github'


get '/' do
	github = Github.new(HttpClient.new)
	log = github.grab_activity('andypaxo')
	haml :git_activity, :locals => { :log => log }
end
