require 'rubygems'
require 'json'
require 'web/httpClient'

class Github

	def initialize
		@client = HttpClient.new('api.github.com', true)
	end
	
	def grab_commits(user, repo)
		raw = @client.get("/repos/#{user}/#{repo}/commits")
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