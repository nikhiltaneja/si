# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

kendall = User.create(name: "Kendall", uid: "1")
evan = User.create(name: "Evan", uid: "2")
laura = User.create(name: "Laura", uid: "3")
jason = User.create(name: "Jason", uid: "4")
peter = User.create(name: "Peter", uid: "5")
paul = User.create(name: "Paul", uid: "6")
mary = User.create(name: "Mary")
diana = User.create(name: "Diana")
lee = User.create(name: "Lee")
kelly = User.create(name: "Kelly")

nyc = Location.find_or_create_by(area: "Greater New York City Area, US")
sf = Location.find_or_create_by(area: "SF")
denver = Location.find_or_create_by(area: "Greater Denver Area, US")

kendall.location = nyc
evan.location = nyc
laura.location = nyc
jason.location = nyc
peter.location = nyc
paul.location = nyc
mary.location = nyc
diana.location = nyc
lee.location = nyc
kelly.location = nyc
