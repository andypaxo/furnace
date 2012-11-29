require 'json'

class Github

	# TODO : This class needs some way of handling HTTP errors

	def initialize(client)
		@client = client.set_server('api.github.com', true)
	end
	
	def set_access_token(token)
		@client.set_params({:access_token=>token})
	end
	
	def grab_activity(user)
		
		raw = @client.get("/users/#{user}/received_events")
		JSON.parse(raw)
	end
	
	def grab_repos(user)
		raw = @client.get("/users/#{user}/repos")
		JSON.parse(raw)
	end
	
	def grab_repo_names(user)
		repos = JSON.parse(@client.get("/users/#{user}/repos"))
		repos.map { |repo|
			{ "name" => repo["name"] }
		}
	end
end