- article = attrs.fetch :article, nil
.media id="#{@id}"
	.media-left
		| FIXME:AUTHOR AVATAR (if any?)
	.media-content
		a href="##{@id}"
			.heading = @author

			.content
				== @body_html
	.media-right
		= @creation_date
		- if article
			br!
			a href="/blog/#{article.title_markdown}/likes/#{@id}"
				= @likers.size
				| 👍

