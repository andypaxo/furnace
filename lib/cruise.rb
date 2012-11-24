require 'lib/web/httpClient'

class Cruise

	# TODO : This class needs some way of handling HTTP errors

	def initialize(client)
		@client = client
	end

	def grab_status
		@client.get('/server/local/XmlStatusReport.aspx')
	end
end