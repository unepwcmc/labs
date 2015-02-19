FactoryGirl.define do
  factory :project_instance do
    project_id { FactoryGirl.create(:project).id }
    stage { ['Staging', 'Production'].sample }
    branch { ['develop', 'master'].sample }
    url Faker::Internet.url
    description Faker::Lorem.paragraph
    name Faker::Company.name
    backup_information Faker::Lorem.paragraph
  end
end