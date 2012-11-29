$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'haml'
require 'base64'
require 'json'
require 'net/http'
require 'lib/github'
require 'lib/cruise'
require 'lib/combined_status'

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
	combined = CombinedStatus.new(
		Github.new(HttpClient.new),
		Cruise.new(HttpClient.new))
	gh, cc = data['github'], data['cc']
	combined.set_github(gh['user'], gh['auth'])
	data['cc'].each { |c|
		combined.add_cruise(c['server'], c['user'], c['pass'])
	}
	haml :combined, :locals => combined.get_status
end