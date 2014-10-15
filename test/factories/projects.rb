FactoryGirl.define do
  factory :project do
    title Faker::Company.name
    description Faker::Lorem.paragraph
    url Faker::Internet.url
    repository_url Faker::Internet.url
    state { ['Under Development', 'Delivered', 'Project Development'].sample }
    internal_client Faker::Name.name
    current_lead Faker::Name.name
    external_clients {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    project_leads {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    developers {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    published true

    factory :draft_project do
        published false
    end
  end
end