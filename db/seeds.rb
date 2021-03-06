# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Track.create(user: 'Edu', status: 'live', latitude: '-12.964935', longitude: '-38.435991', heading: '10', speed: '11')
Track.create(user: 'Dudu', status: 'live', latitude: '-12.963931', longitude: '-38.435175', heading: '12', speed: '9')
Track.create(user: 'Du', status: 'live', latitude: '-12.964831', longitude: '-38.435926', heading: '90', speed: '10')
Track.create(user: 'Fre', status: 'off', latitude: '-12.964559', longitude: '-38.435626', heading: '180', speed: '10')