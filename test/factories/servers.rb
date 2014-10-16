FactoryGirl.define do
  factory :server do
    name Faker::Name.name
    domain Faker::Internet.url
    username Faker::Internet.user_name
    admin_url Faker::Internet.url
    os { ['Windows', 'Linux'].sample }
    description Faker::Lorem.paragraph
  end
end