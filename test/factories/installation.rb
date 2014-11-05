FactoryGirl.define do
  factory :installation do
    project_id { FactoryGirl.create(:project).id }
    server_id { FactoryGirl.create(:server).id }
    role { ['Web', 'Database', 'Web & Database'].sample }
    stage { ['Staging', 'Production'].sample }
    branch { ['develop', 'master'].sample }
    url Faker::Internet.url
    description Faker::Lorem.paragraph
  end
end