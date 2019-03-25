# TODO: Write documentation for `ORM`
require "clear"
module ORM
  VERSION = "0.1.0"


  # TODO: Put your code here

	# initialize a pool of database connection:
	Clear::SQL.init("postgres://postgres@localhost/altideal", connection_pool_size: 5)

	class Dealer
		include Clear::Model
		self.table = "dealer"

		column name : String, presence: false
		column website : String?
		column source_creation : String?

		primary_key  #column id : Int32, primary: true, presence: false
		has_many posts : Deal
		dealer= Dealer.query
	end

	class Brand
		include Clear::Model
		self.table = "orm_brands" # ou nommage de dans la base orm_brands
		primary_key  #column id : Int32, primary: true, presence: false

		column brand_name : String

		has_many posts : Deal
		brand= Brand.query
	end

	class Deal
		include Clear::Model
		self.table = "deal"
		primary_key #name: "id", type: :bigint
#			iprimary: true, presence: false

		column title : String, presence: false
		column description : String?
		column link : String?
		column original_price : Int32
		column current_price : Int32
		column rating : Int16

		belongs_to  dealer : Dealer, primary: true
		belongs_to brand : Brand, primary: true
		deal= Deal.query
	end

	a = Brand.new({brand_name: "ma nouvelle marque" })
	a.save!
	puts "Nouvelle marque saved ad=#{a.id}"

	b = Dealer.new({name: "encore un revendeur de plus" })
	b.save!
	puts "Nouvelle marque saved as id=#{b.id}"

	c = Deal.new({
		title: "nouveau titre",
		description: "encore une promo de xxxxx",
		original_price: "100",
		current_price: 50,
		rating: 4,
		dealer: b,
		brand: a
	})
	c.save!
	puts "Nouveau Deal id=#{c.id}"

#	array_of_brand =  Brand.query.to_a
#	pp array_of_brand

end
