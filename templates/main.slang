doctype html
html
	head
		meta charset="utf-8"
		- if page_title
			title みい-ちゃん - #{page_title}
		- else
			title みい-ちゃん

		/ CSS should probably be removed once SASS
		/ is made part of the toolchain.
		link href="/style.css" rel="stylesheet"

	body
		== Kilt.render "templates/navbar.slang"

		== yield

		== Kilt.render "templates/footer.slang"
