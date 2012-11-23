$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'haml'
require 'lib/github'

get '/' do
	haml :index
end

post '/activity' do
	redirect "/activity/#{params[:user]}?auth=#{params[:auth]}"
end

get '/activity/:user' do
	github = Github.new(HttpClient.new)
	p "Using auth token: #{params[:auth]}"
	github.set_access_token(params[:auth])
	log = github.grab_activity(params[:user])
	haml :git_activity, :locals => { :log => log }
end
