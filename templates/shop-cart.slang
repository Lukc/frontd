
.section
	.container
		- cart = env.shop_cart
		- if cart
			.columns
				.column.is-half
					== cart.articles.map(&.to_html_cart env).reduce "" { |acc, e| acc + e }
					br
				.column
					| Total: 
					= cart.articles.reduce 0 { |acc, e| acc + e.price }
		- else
			.content
				h3 Your cart is empty!
				p This page displays the content of your cart, but your cart is empty.
				p Nothing to do, here! You probably want to go back to the shop.

