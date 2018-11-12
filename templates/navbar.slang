nav class="navbar"
	div class="container"
		div class="navbar-brand"
			span class="navbar-item"
				img src="/logo.png" alt="Esprit Bourse"
		div class="navbar-menu is-active"
			div class="navbar-start"
				/ FIXME: Those should probably be somewhat more automated. plz
				a href="/" class="navbar-item"
					| 🏠\u{FE0E}
				a href="/blog" class="navbar-item"
					| Blog
				a href="/shop" class="navbar-item"
					| Shop
				a href="/forum" class="navbar-item"
					| Forum
		div class="navbar-end"
			- user.try do |user|
				a href="/login" class="navbar-item"
					div class="avatar"
						| XXX
					| #{user.username.to_s}
			- (!user).try do
				a href="/login" class="navbar-item" Login
			
