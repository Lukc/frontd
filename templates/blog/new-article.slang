
.section
	.container
		form action="/blog/articles?from=#{env.request.resource}" method="post"
			label.label Title
			input.input type="text" name="title"

			label.label Author
			input.input type="text" disabled=true placeholder=(env.authd_user.try &.login)

			label.label Text
			textarea.input name="body"

			input.button type="submit" value="Send!"

