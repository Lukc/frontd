require "clear"

#initialize a pool of database connection:
Clear::SQL.init("postgres://postgres@localhost/Alti1", connection_pool_size: 5)

class Country
	include Clear::Model
	self.table = "countries"
	primary_key

	column name  : String

	has_many deals : Deal
	has_many geographic_position : GeographicPosition
	country = Country.query
end


class LinkDatabaseUser 
	include Clear::Model
	self.table = "link_database_users"
	primary_key

	column uuid : UUID

	has_many deals : Deal
	linkdatabaseuser = LinkDatabaseUser.query
end

class Dealer
	include Clear::Model
	self.table = "dealers"

	column name : String, presence: false
	column website : String?
#	column source_creation : String?

	primary_key
	has_many deals : Deal
	dealer= Dealer.query
end

class Brand
	include Clear::Model
	self.table = "brands" # ou nommage de dans la base orm_brands
	primary_key  #column id : Int32, primary: true, presence: false

	column brand_name : String

	has_many brands : Brand
	brand= Brand.query
end

class Product
	include Clear::Model
	self.table = "brands"
	primary_key

	column isin_code : String?
	column product_rating : Int16
	column official_product_link : String?
	
	belongs_to dealer : Dealer, primary: true
	belongs_to brand : Brand, primary: true
end

class DealCategory 
	include Clear::Model
	self.table ="deal_categories"
	column title : String
	primary_key 
end


class DealGeographicPosition
	include Clear::Model
	self.table = "deal_geographic_positions"
	primary_key 
	
end

class GeographicPosition
	include Clear::Model
	self.table = "geographic_positions"
	primary_key
	column geographic_name : String
	belongs_to geographic_data_type : GeographicDataType, primary: true
	belongs_to country : Country, primary: true
	has_many geographic_position : Deal, through: "deal_geographic_positions"
end

class GeographicDataType
	include Clear::Model
	self.table = "geographic_data_types"
	primary_key 
	column geographic_type : String
	has_many geographic_positions : GeographicPosition
	
end



class Deal
	include Clear::Model
	self.table = "deals"
	primary_key 
	
	column uuid : UUID
	column title : String 
	column description : String?
	column original_price : Int32?
	column current_price : Int32?
	column deal_rating : Int16
	column link_to_detail_deal : String?
	column date_start : Time?
	column date_end : Time?
	column date_row_created : Time?
	column date_row_modified : Time?
	column is_free : Bool
	column code_promo : String?
	
	belongs_to  dealer : Dealer, primary: true
	belongs_to brand : Brand, primary: true
	belongs_to link_database_user : LinkDatabaseUser, primary: true
	has_many geographic_positions : GeographicPosition, through: "deal_geographic_positions"
	deal= Deal.query
end


#dataset initial 
require  "./dataset.cr"


#some debug tools
dataset = Country.query.where(name: "France")
dataset = Country.query
array_dataset = Country.query.to_a

pp dataset.select("France")
pp array_dataset[0].name

#pp  "#{dataset.select.("id")}"
#puts "Pays  id=#{dataset.id}"


brand = Brand.new({brand_name: "ma nouvelle marque" })
brand.save!
puts "Nouvelle marque saved ad=#{brand.id}"

vendeur = Dealer.new({name: "encore un revendeur de plus" })
vendeur.save!
puts "Nouvelle marque saved as id=#{vendeur.id}"

user= LinkDatabaseUser.new({
	uuid: UUID.random
})
user.save!
puts "Nouvel utilisateur saved as id=#{user.id}"

deal = Deal.new({
	title: "le titre",
	description: "encore une promo de xxxxx",
	deal_rating: 4,
	dealer: vendeur,
	brand: brand,
	link_database_user: user,
	uuid: UUID.random,
	date_start: Time.now,
	is_free: false ,
})
deal.save!
puts "Nouveau Deal id=#{deal.id}"

deal.geographic_positions << GeographicPosition.query.find_or_create({geographic_name: "Strasbourg_test"}){}


