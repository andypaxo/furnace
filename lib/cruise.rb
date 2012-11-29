require 'lib/web/httpClient'
require 'rexml/document'

class Cruise

	# TODO : This class needs some way of handling HTTP errors

	def initialize(client)
		@client = client
	end

	def grab_status(server, user, pass)
		@client.set_server(server, false)
		session_token = get_session_token(user, pass)
		response = get_status(session_token)
		
		response_xml = REXML::Document.new response
		response_xml.elements[1].each.map { |project|
			{
				:name => project.attributes['name'],
				:status => project.attributes['buildStatus']
			}
		}
	end
	
	private ##############################################################################
	
	def get_session_token(user, pass)
		xml =
"<loginMessage>
	<credential name='userName' value='#{user}' />
	<credential name='password' value='#{pass}' />
</loginMessage>"
		login_response = @client.post(
			'/server/local/RawXmlMessage.aspx',
			"action=Login&message=#{xml}")
		login_xml = REXML::Document.new login_response
		login_xml.elements[1].attributes['sessionToken']
	end
	
	def get_status(session_token)
		session_token
		xml = "<serverMessage session='#{session_token}' />"
		@client.post(
			'/server/local/RawXmlMessage.aspx',
			"action=GetProjectStatus&message=#{xml}")
	end
end
