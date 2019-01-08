
require "../errors.cr"

# FIXME: This is the most critical part to deduplicate.
def main_template(env, **attrs, &block)
	user = env.authd_user

	page_title = attrs.fetch :title, nil

	Kilt.render "templates/main.slang"
end

class Blog::Article
	# FIXME: The /blog part should be somewhat configurable. Articles need
	#        a reference to their Blog instance!
	def generate_url
		"/blog/#{HTML.escape @title_markdown}"
	end
end

class Blog
	def export_index
		get "/blog" do |env|
			current_article = nil

			main_template(env) {
				Kilt.render "templates/blog.slang"
			}
		end
	end

	def export_articles_pages
		get "/blog/:title" do |env|
			title = HTML.unescape env.params.url["title"]

			# Note: should match Blog::Article#generate_url.
			current_article = articles.find &.title_markdown.==(title)

			if current_article.nil?
				next halt env, status_code: 404
			end

			main_template(env) {
				Kilt.render "templates/blog.slang"
			}
		end
	end

	def export_articles_input_pages(dashboard : FrontD::Dashboard? = nil)
		if dashboard
			get "/dashboard/blog" do |env|
				user = env.authd_user
				# FIXME: Configuration & Permissions.
				if user.nil? || ! user.groups.any? &.==("blog")
					env.response.status_code = 403
					raise FrontD::AuthenticationError.new "You do not have permissions to create new articles."
				end

				dashboard.render(env) {
					Kilt.render "templates/dashboard/blog.slang"
				}
			end
		end

		post "/blog/articles" do |env|
			from = env.params.query["from"]?

			# FIXME: Client-side will also need JS integration to show missing/empty fields and such.

			title = get_safe_input env, "title"
			body = get_safe_input env, "body"

			begin
				user = env.authd_user.not_nil!
				author = user.login
			rescue
				env.response.status_code = 403
				raise FrontD::AuthenticationError.new "You must be logged in!"
			end

			# FIXME: Configuration. Several blogs on a single website may want
			#        different groups.
			if ! user.groups.any? &.==("blog")
				env.response.status_code = 403
				raise FrontD::AuthenticationError.new "You need to be part of the 'blog' group to create blog articles!"
			end

			article = Blog::Article.new title: title, author: author, body: body

			self << article

			env.redirect from || "/blog"
		end
	end

	def export_all_routes(dashboard : FrontD::Dashboard? = nil)
		export_articles_pages
		export_index
		export_articles_input_pages dashboard
	end

	def dashboard_page
		Dashboard::Page.new "/blog", "Blog" do |user|
			user.groups.any? &.==("blog")
		end
	end
end

