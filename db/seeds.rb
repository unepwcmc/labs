# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#FIXME: seeds need updating to match new product details and fix errors

Product.delete_all
Server.delete_all
Installation.delete_all

9.times do |n|
  Product.create!(
    title: ['Protected Planet', 'Ocean Data Viewer', 'Blue Carbon Layer', 
            'Marine Data Validation', 'Apes Dashboard', 'Global Islands Database', 
            'REDD+ Database', 'CITES Checklist', 'Species Database'][n-1],
    description: Faker::Lorem.paragraph,
    url: Faker::Internet.url,
    github_identifier: Faker::Internet.url,
    state: ['Under Development', 'Delivered', 'Project Development'].sample,
    internal_clients: [ Faker::Name.name, Faker::Name.name, Faker::Name.name],
    current_lead: Faker::Name.name,
    external_clients: [ Faker::Name.name, Faker::Name.name, Faker::Name.name],
    product_leads: [ Faker::Name.name, Faker::Name.name, Faker::Name.name],
    developers: [ Faker::Name.name, Faker::Name.name, Faker::Name.name],
    published: true
  )
end

3.times do |n|
    Server.create!(
        name: "Server_#{n}",
        domain: Faker::Internet.url,
        username: Faker::Internet.user_name,
        admin_url: Faker::Internet.url,
        os: ['Windows', 'Linux'].sample,
        description: Faker::Lorem.paragraph
    )
end

6.times do |n|
    Installation.create!(
        product_id: Product.order("RANDOM()").first.id,
        server_id: Server.order("RANDOM()").first.id,
        role: ['Web', 'Database', 'Web & Database'].sample,
        stage: ['Staging', 'Production'].sample,
        branch: ['develop', 'master'].sample,
        url: Faker::Internet.url,
        description: Faker::Lorem.paragraph
    )
end

puts "Cleared database, added 9 products, 3 servers and 6 new installations!"