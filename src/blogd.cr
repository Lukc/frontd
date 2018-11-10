require "blogd"
require "ipc"

class BlogD::Article
	def to_html
		HTML.build {
			div class: "hero is-info is-bold blog-picture" {
				div class: "hero-body" {
				}
			}
			
			div class: "section blog-item" {
				div class: "container" {
					article class: "card article" {
						div class: "card-content" {
							div class: "media" {
								div class: "media-content has-text-centered" {
									a href: "/blog/" + @title {
										h2 class: "title is-1" {
											text @title
										}
									}

									@subtitle.try do |subtitle|
										h3 class: "subtitle is-2" {
											text subtitle
										}
									end

									@author.try do |author|
										div class: "subtitle is-6 author" {
											text author
										}
									end
								}
							}

							div class: "content article-body" {
								html @html_body
							}
						}
					}
				}
			}
		}
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

