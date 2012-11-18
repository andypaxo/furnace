$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'http/httpClient'

client = HttpClient.new('api.github.com', true)
puts client.get('/repos/andypaxo/euler/commits')