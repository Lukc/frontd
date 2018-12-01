require "blogd"
require "ipc"
require "kilt/slang"

class BlogD::Article
	def to_html
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

