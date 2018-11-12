
.hero.is-info.is-bold.blog-picture
	.hero-body
		/ Currently empty. Article picture will
		/ be here in the future.

.section.blog-item
	.container
		article.card.article
			.card-content
				.media
					.media-content.has-text-centered
						a href="/blog/#{@title}"
							h2.title.is-1
								= @title
						- @subtitle.try do |subtitle|
							h3.subtitle.is-2
								= subtitle

						- @author.try do |author|
							.subtitle.is-6.author
								= author

				.content.article-body
					== @html_body

