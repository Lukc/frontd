doctype html
html
	head
		meta charset="utf-8"
		title
			== page_title
		link href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.1/css/bulma.min.css" rel="stylesheet"

		/ CSS should probably be removed once SASS
		/ is made part of the toolchain.
		link href="/style.css" rel="stylesheet"

	body
		== Kilt.render "templates/navbar.slang"

		== yield

		== Kilt.render "templates/footer.slang"
