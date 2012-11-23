$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'haml'
require 'lib/github'
require 'base64'

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

post '/cc_build' do
	auth = Base64.encode64("#{params[:user]}:#{params[:pass]}")
	redirect "/cc_build/#{params[:server]}?auth=#{auth}"
end

get '/cc_build/:server' do
	return Base64.decode64(params[:auth])
end