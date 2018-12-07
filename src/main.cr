
require "kemal"
require "kemal-session"
require "html_builder"
require "kilt/slang"

require "ipc"

require "./authd.cr"
require "./builder.cr"
require "./blogd.cr"

require "authd"

blogd = BlogD::Client.new "blogd"
authd = AuthD::Client.new

add_authd_cli_options authd
add_authd_middleware authd

Kemal::Session.config.secret = "I wanted to mule but I’m all out of Reppuu."

def main_template(env, **attrs, &block)
	user = env.authd_user

	page_title = attrs.fetch :title, nil

	page_title = if page_title
		"Esprit Bourse - #{page_title}"
	else
		page_title = "Esprit Bourse"
	end

	Kilt.render "templates/main.slang"
end

get "/" do |env|
	blog_response = blogd.get_all_articles

	blog_articles = blog_response.try &.articles

	main_template(env) {
		Kilt.render "templates/index.slang"
	}
end

get "/login" do |env|
	user = env.authd_user
	login_error = nil

	main_template(env) { Kilt.render "templates/login.slang" }
end

get "/logout" do |env|
	env.session.destroy
	env.redirect "/"
end

post "/login" do |env|
	user = nil

	username = env.params.body["login"]?
	password = env.params.body["password"]?

	login_error = nil

	if username.nil?
		login_error = "“Login” field was left empty!"
	end
	if password.nil?
		login_error = "“Password” field was left empty!"
	end

	if login_error
		next main_template(env) { Kilt.render "templates/login.slang" }
	end

	# Should have next’d with a login error beforehand if those had been nil.
	username = username.not_nil!
	password = password.not_nil!

	token = authd.get_token? username, password

	if token
		env.session.string "token", token
	else
		login_error = "Invalid credentials!"
		next main_template(env) { Kilt.render "templates/login.slang" }
	end

	env.redirect "/login"
end

get "/blog" do |env|
	blogd.send 0, ""

	response = blogd.get_all_articles

	articles = response.articles

	main_template(env) {
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
					html article.to_html env
				end
			end
		}
	}
end

get "/blog/:title" do |env|
	title = env.params.url["title"]

	article = blogd.get_article(title).try &.article

	if article
		main_template(env) {
			article.to_html env
		}
	else
		"<h1>FIXME: 404</h1>"
		# FIXME: Throw a 404 error.
	end
end

get "/shop" do |env|
	main_template(env) {
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
	main_template(env) {
		HTML.build {
			section {
				container {
					text "FORUM HERE"
				}
			}
		}
	}
end

error 404 do |env|
	main_template(env) {
	}
end

Kemal.run

