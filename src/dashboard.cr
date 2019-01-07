
class FrontD::Dashboard
	def initialize()
	end

	def render(env, **attrs, &block)
		user = env.authd_user

		# FIXME: Being logged in should not be enough.
		if user.nil?
			env.response.status_code = 403
			raise FrontD::AuthenticationError.new "You need to be logged in to access the dashboard!"
		end

		main_template(env) {
			Kilt.render "templates/dashboard.slang"
		}
	end

	def export_all_routes
		get "/dashboard" do |env|
			render(env) {}
		end
	end
end

