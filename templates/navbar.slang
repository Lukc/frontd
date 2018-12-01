nav.navbar
	.container
		.navbar-brand
			span.navbar-item
				img src="/logo.png" alt="Esprit Bourse"
		.navbar-menu.is-active
			.navbar-start
				/ FIXME: Those should probably be somewhat more automated. plz
				a.navbar-item href="/"
					| 🏠\u{FE0E}
				a.navbar-item href="/blog"
					| Blog
				a.navbar-item href="/shop"
					| Shop
				a.navbar-item href="/forum"
					| Forum
		.navbar-end
			- if user
				a.navbar-item href="/login"
					.image.is-24x24.avatar
						img.is-rounded src="https://bulma.io/images/placeholders/24x24.png" alt="User Avatar"
					| #{user.username.to_s}

				a.navbar-item href="/logout"
					| Logout
			- else
				a.navbar-item href="/login" Login
			
