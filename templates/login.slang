
.section
	.container
		- login_error.try do
			== login_error
				
		- if user
			| FIXME: print user data or something here.

		- else
			form method="POST" action="/login"
				.field
					label.label Login
					input.input name="login"

				.field
					label.label Password
					input.input type="password" name="password"

				.control
					input.button type="submit" value="Log in"

