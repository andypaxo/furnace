class CombinedStatus
	def initialize(github, cc)
		@github, @cc = github, cc
		@cruise_auths = []
	end

	def set_github(user, pass)
		@gh_auth = GHLogin.new(user, pass)
		@github.set_access_token(pass)
	end

	def add_cruise(server, user, pass)
		@cruise_auths.push CruiseLogin.new(server, user, pass)
	end

	def get_status
		return {
			:github => @github.grab_activity(@gh_auth.user),
			:status => get_cc_status
		}
	end

	private

	def get_cc_status
		@cruise_auths.map { |auth|
			@cc.grab_status(auth.server, auth.user, auth.pass)
		}.flatten
	end
	
	class GHLogin
		attr_accessor :user, :pass

		def initialize(user, pass)
			@user, @pass = user, pass
		end
	end

	class CruiseLogin
		attr_accessor :server, :user, :pass

		def initialize(server, user, pass)
			@server, @user, @pass = server, user, pass
		end
	end
end