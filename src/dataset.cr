#comment this lignes to insert dataset the first time
#france_test = Country.query.where(name: "Franceg")
#if ! france_test[0].name ==  "France"
#	pp france_test[0]

datasetpays = Country.new({name: "France_test"})
datasetpays.save!

datasetgeotype = GeographicDataType.new({geographic_type: "Ville_test"})
datasetgeotype.save!

datasetgeo = GeographicPosition.new({geographic_name: "Strasbourg_test",
														country: datasetpays,
														geographic_data_type: datasetgeotype
})
datasetgeo.save!

	dataset = Country.new({name: "France"})
	dataset.save!
	dataset = Country.new({name: "Allemagne"})
	dataset.save!
	dataset = Country.new({name: "Italie"})
	dataset.save!
	dataset = Country.new({name: "Espagne"})
	dataset.save!
	dataset = Country.new({name: "Belgique"})
	dataset.save!
	dataset = Country.new({name: "Luxembourg"})
	dataset.save!
	dataset = Country.new({name: "Suisse"})
	dataset.save!


	dataset = DealCategory.new({title: "Alimentation & Boissons"})
	dataset.save!
	dataset = DealCategory.new({title: "Auto, Moto & Scooter"})
	dataset.save!
	dataset = DealCategory.new({title: "Banques, Assurances & Crédits"})
	dataset.save!
	dataset = DealCategory.new({title: "Consoles & Jeux vidéos"})
	dataset.save!
	dataset = DealCategory.new({title: "Divertissements, Loisirs & Culture"})
	dataset.save!
	dataset = DealCategory.new({title: "Fournitures pour animaux"})
	dataset.save!
	dataset = DealCategory.new({title: "Image, Son & Vidéo"})
	dataset.save!
	dataset = DealCategory.new({title: "Informatique & Electronique"})
	dataset.save!
	dataset = DealCategory.new({title: "Jeux & Jouets"})
	dataset.save!
	dataset = DealCategory.new({title: "Logiciels & Applications"})
	dataset.save!
	dataset = DealCategory.new({title: "Maison, Bricolage & Jardin"})
	dataset.save!
	dataset = DealCategory.new({title: "Puériculture & Enfants"})
	dataset.save!
	dataset = DealCategory.new({title: "Santé, Beauté & Bien-être"})
	dataset.save!
	dataset = DealCategory.new({title: "Services divers"})
	dataset.save!
	dataset = DealCategory.new({title: "Sports & Activités extérieures"})
	dataset.save!
	dataset = DealCategory.new({title: "Téléphonie & Internet"})
	dataset.save!
	dataset = DealCategory.new({title: "Vêtements, Chaussures & Accessoires pour femme"})
	dataset.save!
	dataset = DealCategory.new({title: "Vêtements, Chaussures & Accessoires pour homme"})
	dataset.save!
	dataset = DealCategory.new({title: "Voyages"})
	dataset.save!


	dataset = GeographicDataType.new({geographic_type: "Ville"})
	dataset.save!
	dataset = GeographicDataType.new({geographic_type: "Département"})
	dataset.save!
	dataset = GeographicDataType.new({geographic_type: "Pays"})
	dataset.save!

#end

