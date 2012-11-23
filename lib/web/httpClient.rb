require 'net/http'
require 'net/https'

class HttpClient
	def set_server(server, useHttps)
		port = useHttps ? 443 : 80
		@http = Net::HTTP.new(server, port)
		@http.use_ssl = useHttps
	end
	
	def set_params(params)
		@params = "?" + (params.map { |name, value|
			"#{name}=#{value}"
		}.join('&'))
	end
	
	def post(path, data)
		request = Net::HTTP::Post.new(make_uri(path))
		request.body = data
			
		@http.request(request).body
	end
	
	def get(path)
		request = Net::HTTP::Get.new(make_uri(path))
		@http.request(request).body
	end	
	
	def make_uri(path)
		uri = URI.encode(path + @params)
		puts "Making request to #{uri}"
		uri
	end
end