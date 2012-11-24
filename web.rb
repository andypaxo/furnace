$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'haml'
require 'base64'
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
	github = Github.new(HttpClient.new)
	p "Using auth token: #{params[:auth]}"
	github.set_access_token(params[:auth])
	log = github.grab_activity(params[:user])
	haml :git_activity, :locals => { :log => log }
end

post '/cc_build' do
	auth = Base64.encode64("#{params[:user]}:#{params[:pass]}")
	server = URI.encode_www_form_component(params[:server])
	redirect "/cc_build?server=#{server}&auth=#{auth}"
end

get '/cc_build' do
	server = HttpClient.new.set_server(params[:server], false)
	cruise = Cruise.new(server)
	# params[:server] + ':' + Base64.decode64(params[:auth])
	cruise.grab_status
end