require 'net/http'
require 'net/https'

class HttpClient
	def initialize(server, useHttps)
		port = useHttps ? 443 : 80
		@http = Net::HTTP.new(server, port)
		@http.use_ssl = useHttps
	end
	
	def post(path, data)
		request = Net::HTTP::Post.new(path)
		request.body = data
		@http.request(request).body
	end
	
	def get(path)
		request = Net::HTTP::Get.new(path)
		@http.request(request).body
	end	
end