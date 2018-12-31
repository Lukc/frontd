
/ FIXME: Display only the last X articles.
- if current_article
	== current_article.to_html
- else
	- each_article do |article|
		== article.to_html

