
require "kemal"
require "html_builder"

require "ipc"

require "./builder.cr"
require "./blogd.cr"

services = [
	{
		prefix: "blog",
		host: "blogd",
		port: 8888
	}
]

blogd = BlogD::Client.new "blogd"

def templateBody(**attrs, &block)
	HTML.build do
		doctype

		html do
			head do
				html "<meta charset=\"utf-8\"/>"
				# FIXME: We want to rebuild that from npm and a SASS compiler.
				link(href: "https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.1/css/bulma.min.css", rel: "stylesheet")

				page_title = attrs.fetch :title, nil
				if page_title
					html "<title>Esprit Bourse — #{page_title}</title>"
				else
					html "<title>Esprit Bourse</title>"
				end

				html %(<style>
					.section.blog-item {
						margin-top: -340px;
					}
					.hero.blog-picture {
						height: 400px;
					}

					.footer {
						background-color: #363636;
						color: #DDD;
					} .footer * {
						color: #DDD;
					}
				</style>)
			end

			body do
				navbar(class: "is-dark") {
					div(class: "navbar-brand") do
						span(class: "navbar-item") do
							img src: "/logo.png", alt: "Esprit Bourse"
						end
					end
					div(class: "navbar-menu is-active") do
						div(class: "navbar-start") do
							navbar_item "🏠\u{FE0E}", "/"
							# FIXME: We’ll probably want an adequate font for that one. Possibly FA.
							navbar_item "Blog", "/blog"
							navbar_item "Shop", "/shop"
							navbar_item "Forum", "/forum"
						end
						div(class: "navbar-end") do
							a(class: "navbar-item", href: "/connect") do
								text "Login"
							end
						end
					end
				}

				html yield

				footer do
					level {
						level_item {
							ul {
								li {
									text "FIXME: 'proper company link' thing"
								}
								li {
									text "FIXME: legal mentions"
								}
								li {
									text "FIXME: about?"
								}
							}
						}
						level_item {
							span class: "title is-3" {
							   text "logo or something"
							}
						}
						level_item {
							ul {
								li {
									text "FIXME: something something"
								}
								li {
									text "FIXME: client something stuff"
								}
							}
						}
					}
				end
			end
		end
	end
end

get "/" do |env|
	begin
		blog_response = blogd.get_all_articles
	rescue e
		p e
	end
	
	blog_articles = blog_response.try &.articles
	
	templateBody {
		HTML.build {
			hero(class: "is-dark is-bold is-medium") {
				hero_body {
					h1(class: "title is-1 has-text-centered") {
						text "Esprit Bourse"
					}
					h2(class: "subtitle is-3 has-text-centered") {
						text "On prend soin de vos Bourses"
					}
				}
			}
			hero(class: "is-dark is-medium") {
				container {
				hero_body {
					columns {
						column(class: "is-8") {
							unless blog_articles
								next
							end

							unless blog_articles.size > 0
								next
							end

							latest_article = blog_articles[0]

							title(level: 3) {
								text latest_article.title
							}

							latest_article.subtitle.try do |subtitle|
								subtitle(level: 4) {
									text subtitle
								}
							end

							latest_article.author.try do |author|
								text "By " + author
							end
						}
						column {
							unless blog_articles
								next
							end

							unless blog_articles.size > 1
								next
							end
								
							title(level: 4) {
								text "Derniers articles :"
							}
							ul {
								blog_articles[1..5].each do |article|
									article.to_html_list_item
								end
							}
						}
					}
				}
				}
			}

			hero(class: "is-dark is-bold is-small") {
				container {
					hero_body {
						section {
							columns {
								column {
									div(class: "has-text-centered") {
										div(class: "title is-1") {
											text "☑"
										}
										title(level: 4) {
											text "ya too ki marsh"
										}
										subtitle(level: 5) {
											html "(presque)"
										}
									}
								}
								column {
									div(class: "has-text-centered") {
										div(class: "title is-1") {
											text "☆"
										}
										title(level: 4) {
											text "on é lé meilleur"
										}
									}
								}
								column {
									div(class: "has-text-centered") {
										div(class: "title is-1") {
											text "☢"
										}
										title(level: 4) {
											text "tro fissile ce projet"
										}
									}
								}
							}
						}
					}
				}
			}

			hero(class: "is-info is-small is-bold") {
				container {
					hero_body {
						title(level: 3) {
							text "Even more content here."
						}
					}
				}
			}

			hero(class: "is-success is-medium is-bold") {
				container {
					hero_body {
						title(level: 2) {
							text "oh wow such content much fun very rich"
						}
					}
				}
			}
		}
	}
end

get "/blog" do |env|
	blogd.send 0, ""

	response = blogd.get_all_articles

	articles = response.articles

	templateBody {
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
		templateBody {
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
	templateBody {
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
	templateBody {
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
	templateBody {
	}
}

Kemal.run

