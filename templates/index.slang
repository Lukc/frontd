/
/ Template for the index page (/).
/
/ TODO:
/ 	- Currently requires a `blog_articles` variable.
/ 	  Maybe we could use the BlogD::Client directly?
/ 	  This would require API improvements, however!
/

.hero.is-dark.is-bold.is-medium
	.hero-body
		h1.title.is-1.has-text-centered
			| Esprit Bourse
		h2.subtitle.is-3.has-text-centered
			| On prend soin de vos Bourses

.hero
	.hero-body
		.columns
			.column.is-8
				- blog_articles.try do |articles|
					- (articles.size > 0).try do
						.title.is-3
							= articles.first.title
			.column
				- blog_articles.try do |articles|
					- (articles.size > 1).try do
						title.is-4 "Derniers articles :"

						ul
							- articles[1..5].each do |article|
								== article.to_html_list_item

.hero.is-dark.is-bold.is-small
	.container
		.hero-body
			section.section
				.columns
					.column
						.has-text-centered
							.title.is-1 "☑"
						h4.title.is-4 "ya too ki marsh"
						h5.subtitle.is-5 "(presque)"
					.column
						.has-text-centered
							.title.is-1 "☑"
						h4.title.is-4 "ya too ki marsh"
						h5.subtitle.is-5 "(presque)"
					.column
						.has-text-centered
							.title.is-1 "☑"
						h4.title.is-4 "ya too ki marsh"
						h5.subtitle.is-5 "(presque)"

.hero.is-info.is-small.is-bold
	.container
		.hero-body
			h3.title.is-3
				text "Even more content here!"
