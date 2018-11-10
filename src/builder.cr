require "html_builder"

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

