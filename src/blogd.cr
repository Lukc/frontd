require "blogd"
require "ipc"
require "kilt/slang"

class BlogD::Article
	def to_html(env)
		user = env.authd_user

		Kilt.render "templates/blogd/article.slang"
	end

	def to_html_list_item
		HTML.build {
			li class: "title is-1" {
				a href: "/blog/" + @title {
					text @title
				}
			}
		}
	end
end

