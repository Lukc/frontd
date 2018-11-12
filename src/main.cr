
require "kemal"
require "html_builder"
require "kilt/slang"

require "ipc"

require "./builder.cr"
require "./blogd.cr"

blogd = BlogD::Client.new "blogd"

def main_template(**attrs, &block)
	page_title = attrs.fetch :title, nil
	
	page_title = if page_title
		"Esprit Bourse - #{page_title}"
	else
		page_title = "Esprit Bourse"
	end

	user = attrs.fetch :user, nil
		
	Kilt.render "templates/main.slang"
end

get "/" do |env|
	begin
		blog_response = blogd.get_all_articles
	rescue e
		p e
	end
	
	blog_articles = blog_response.try &.articles
	
	main_template {
		Kilt.render "templates/index.slang"
	}
end

get "/blog" do |env|
	blogd.send 0, ""

	response = blogd.get_all_articles

	articles = response.articles

	main_template {
		HTML.build {
			if articles.size == 0
				section class: "section" {
					div class: "container" {
						p class: "title is-2 has-text-centered" {
							text "No content here!"
						}

						p class: "subtitle is-2 has-text-centered" {
							text "Maybe something will be posted in the future."
						}
					}
				}
			else
				articles.each do |article|
					html article.to_html
				end
			end
		}
	}
end

get "/blog/:title" do |env|
	title = env.params.url["title"]

	article = blogd.get_article(title).try &.article

	if article
		main_template {
			HTML.build {
				html article.to_html
			}
		}
	else
		"<h1>FIXME: 404</h1>"
		# FIXME: Throw a 404 error.
	end
end

get "/shop" do |env|
	main_template {
		HTML.build {
			section {
				container {
					text "SHOP HERE"
				}
			}
		}
	}
end

get "/forum" do |env|
	main_template {
		HTML.build {
			section {
				container {
					text "FORUM HERE"
				}
			}
		}
	}
end

error 404 {
	main_template {
	}
}

Kemal.run

