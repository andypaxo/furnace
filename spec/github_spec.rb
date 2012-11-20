require 'github'
require 'web/httpClient'

describe 'github' do
	it 'should download commit messages' do
		sut = Github.new(FakeHttpClient.new)
		commits = sut.grab_activity('andypaxo')
		
	end
end

class FakeHttpClient < HttpClient
	def get(path)
		# TODO : Also have to verify auth
		if (path == '/users/andypaxo/received_events')
			'[{"type":"Event","actor":{"login":"DHH"}}]'
		end
	end
end