
require "kemal"
require "html_builder"
require "blogd"

services = [
	{
		prefix: "blog",
		host: "localhost",
		port: 8888
	}
]

struct HTML::Builder
	private def hash_attributes(attrs)
		new_attrs = Hash(Symbol, String).new
		attrs.each do |key, value|
			if value.is_a? Int32
				value = value.to_s
			end

			new_attrs[key] = value
		end
		new_attrs
	end
	def navbar(**attrs)
		attrs = hash_attributes attrs

		if attrs[:class]?
			attrs[:class] = "navbar " + attrs[:class]
		else
			attrs[:class] = "navbar"
		end

		@str << "<nav"
		append_attributes_string attrs
		@str << ">"
		container {
			with self yield self
		}
		@str << "</nav>"
	end

	def navbar_item(name, url)
		a(class: "navbar-item", href: url) {
			text name
		}
	end

	{% for tag in %w(section container content level column columns card card-content card-header hero hero-body box)  %}
	def {{tag.id.gsub /-/ , "_"}}(**attrs)
		attrs = hash_attributes attrs

		if attrs[:class]?
			attrs[:class] = "{{tag.id}} " + attrs[:class]
		else
			attrs[:class] = "{{tag.id}}"
		end

		@str << "<div"
		append_attributes_string attrs
		@str << ">"
		with self yield self
		@str << "</div>"
	end
	{% end %}

	{% for tag in %w{} %}

	{% end %}

	{% for tag in %w{title subtitle} %}
	def {{tag.id}}(**attrs)
		attrs = hash_attributes attrs

		if attrs[:class]?
			attrs[:class] = "{{tag.id}} " + attrs[:class]
		else
			attrs[:class] = "{{tag.id}}"
		end

		level = 1

		if attrs[:level]?
			level = attrs[:level]
			attrs.delete :level
		end

		attrs[:class] = attrs[:class] + " is-#{level}"

		@str << "<h#{level}"
		append_attributes_string attrs
		@str << ">"
		with self yield self
		@str << "</h#{level}>"
	end
	{% end %}

	def footer(**attrs)
		attrs = hash_attributes attrs

		if attrs[:class]?
			attrs[:class] = "footer " + attrs[:class]
		else
			attrs[:class] = "footer"
		end

		@str << "<footer"
		append_attributes_string attrs
		@str << ">"
		container {
			with self yield self
		}
		@str << "</footer>"
	end

	def level_item(**attrs)
		attrs = hash_attributes attrs

		if attrs[:class]?
			attrs[:class] = "level-item " + attrs[:class]
		else
			attrs[:class] = "level-item"
		end


		@str << "<div"
		append_attributes_string attrs
		@str << ">"
		with self yield self
		@str << "</div>"
	end
end

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
	templateBody {
		blog_articles_response = HTTP::Client.new(services[0][:host], services[0][:port]).get("/articles")
		blog_articles = Array(BlogD::Article).from_json blog_articles_response.body

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
							title(level: 4) {
								text "Derniers articles :"
							}
							ul {
								blog_articles[1..blog_articles.size].each do |article|
									li {
										a(class: "title is-5", href: "/blog/" + article.title) {
											text article.title
										}
									}
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

def microservice(name : String, host : String, port : Int32)
	{% for route in %w("/#{name}" "/#{name}/*") %}
	get {{route.id}} do |env|
		path = env.request.path.gsub (/^\// + name), ""
		path = "/" if path == ""

		response = HTTP::Client.new(host, port).get(path)
		status_code = response.status_code
		title = response.headers["X-Title"]?

		if status_code != 200
			body = templateBody title: "#{status_code}" {
				HTML.build {
					section {
						container(class: "has-text-centered") {
							h2 class: "title is-1" {
								text "#{status_code}"
							}
							h3 class: "subtitle is-2" {
								if status_code == 404
									text "The requested resource was not found."
								elsif status_code == 503
									text "Something’s broken inside!"
								else
									text "An unexpected error occured."
								end
							}
							text "FIXME: More explanations about things?"
						}
					}
				}
			}

			halt env, status_code: status_code, response: body
		end

		templateBody(title: title) {
			response.body
		}
	end
	{% end %}
end

services.each do |x|
	microservice x[:prefix], x[:host], x[:port]
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

