$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'haml'
require 'base64'
require 'json'
require 'net/http'
require 'lib/github'
require 'lib/cruise'

get '/' do
	haml :index
end

post '/activity' do
	redirect "/activity/#{params[:user]}?auth=#{params[:auth]}"
end

get '/activity/:user' do
	log = github_activity(params[:user], params[:auth])
	haml :git_activity, :locals => { :log => log }
end

post '/cc_build' do
	auth = Base64.encode64("#{params[:user]}:#{params[:pass]}")
	server = URI.encode_www_form_component(params[:server])
	redirect "/cc_build?server=#{server}&auth=#{auth}"
end

get '/cc_build' do
	auth = Base64.decode64(params[:auth])
	user, pass = auth.split(':')
	server = params[:server]
	
	status = cc_status(server, user, pass)
	haml :ci, :locals => { :status => status }
end

get '/combined' do
	data = JSON.parse(params[:params])
	gh, cc = data['github'], data['cc']
	haml :combined, :locals => {
		:github => github_activity(gh['user'], gh['auth']),
		:status => cc_status(cc['server'], cc['user'], cc['pass'])
	}
end

def github_activity(user, auth)
	github = Github.new(HttpClient.new)
	github.set_access_token(auth)
	github.grab_activity(user)
end

def cc_status(server, user, pass)
	client = HttpClient.new.set_server(server, false)
	cruise = Cruise.new(client)	
	cruise.grab_status(user, pass)
end