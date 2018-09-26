
require "kemal"
require "html_builder"

struct HTML::Builder
	private def hash_attributes(attrs)
		new_attrs = Hash(Symbol, String).new
		attrs.each do |key, value|
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
		with self yield self
		@str << "</nav>"
	end

	def navbar_item(name, url)
		a(class: "navbar-item", href: url) {
			text name
		}
	end

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
		with self yield self
		@str << "</footer>"
	end
end

def templateBody(&block)
	HTML.build do
		doctype

		html do
			head do
				html "<meta charset=\"utf-8\"/>"
				# FIXME: We want to rebuild that from npm and a SASS compiler.
				link(href: "https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.1/css/bulma.min.css", rel: "stylesheet")
			end

			body do
				navbar(class: "is-primary") {
					div(class: "navbar-brand") do
						a(class: "navbar-item", href: "/") do
							h1 do
								text "Lala — Online"
							end
						end
					end
					div(class: "navbar-menu") do
						div(class: "navbar-start") do
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

				div(class: "section") do
					div(class: "container") do
						html yield
					end
				end

				footer do
					text "FOOTER HERE"
				end
			end
		end
	end
end

get "/" do |env|
	templateBody {
		HTML.build {
			text "INDEX HERE"
		}
	}
end

class BlogD
	class Article
		property title : String

		def initialize(@title)
		end

		def to_html
			HTML.build {
				article(class: "section") {
					h1(class: "title is-1") {
						text @title
					}

					div(class: "content") {
						p {
							text "Lorem ipsum dolor amet selfies before they sold out pork belly meh meditation consequat edison bulb jianbing dolore authentic copper mug DIY. Ut 3 wolf moon copper mug stumptown godard cold-pressed ea cred craft beer banh mi YOLO semiotics. Brooklyn dolor four dollar toast exercitation 90's coloring book. Proident vegan listicle, VHS deserunt commodo iceland retro ennui enamel pin aesthetic."
						}

						p {
							text "Af fingerstache cold-pressed, pabst scenester proident actually aute disrupt. Irony messenger bag next level veniam, farm-to-table skateboard flannel gluten-free quis consectetur. Small batch put a bird on it fashion axe squid ut anim, heirloom etsy esse taiyaki brooklyn paleo. Bespoke PBR&B heirloom poke YOLO four loko squid irure deserunt meditation laborum gastropub brunch. Schlitz hell of DIY, cold-pressed quinoa shabby chic unicorn tbh elit nulla exercitation snackwave hexagon williamsburg officia. Hot chicken laboris hell of green juice. Pickled single-origin coffee narwhal paleo, +1 chartreuse ut la croix af banjo duis."
						}

						p {
							text "Meh selvage next level listicle. Direct trade in irony fashion axe, salvia kitsch incididunt iPhone echo park wayfarers cornhole skateboard jean shorts. Art party ugh tempor yuccie thundercats. Bicycle rights ea af vape elit sriracha. Succulents aliqua vape skateboard vaporware gentrify deserunt tempor duis kale chips vegan irony iPhone."
						}
					}
				}
			}
		end
	end
	def self.articles
		[
			Article.new("Blip"),
			Article.new("Bloop")
		]
	end
end

get "/blog" do |env|
	templateBody {
		HTML.build {
			BlogD.articles.each { |x| html x.to_html }
		}
	}
end

get "/shop" do |env|
	templateBody {
		HTML.build {
			text "SHOP HERE"
		}
	}
end

Kemal.run

