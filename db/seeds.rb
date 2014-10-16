# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

3.times do
  Project.create!(
    title: Faker::Company.name,
    description: Faker::Lorem.paragraph,
    url: Faker::Internet.url,
    repository_url: Faker::Internet.url,
    state: ['Under Development', 'Delivered', 'Project Development'].sample,
    internal_client: Faker::Name.name,
    current_lead: Faker::Name.name,
    external_clients: [ Faker::Name.name, Faker::Name.name, Faker::Name.name],
    project_leads: [ Faker::Name.name, Faker::Name.name, Faker::Name.name],
    developers: [ Faker::Name.name, Faker::Name.name, Faker::Name.name],
    published: true
  )
end

puts "Added 3 new seed projects!"