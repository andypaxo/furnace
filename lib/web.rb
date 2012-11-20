$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'github'


get '/' do
	github = Github.new(HttpClient.new)
	return github.grab_repo_names('andypaxo').to_s
end
