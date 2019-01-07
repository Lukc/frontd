
.columns
	.column.is-one-quarter
		.menu
			/ FIXME: That list NEEDS to be dynamic and items’ permissions checked.
			ul.menu-list
				li
					a href="/dashboard" Dashboard
					a href="/dashboard/blog" Blog

	.column
		== yield

