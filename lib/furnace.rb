$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'github'

github = Github.new
p github.grab_repo_names('andypaxo')