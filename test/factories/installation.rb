FactoryGirl.define do
  factory :installation do
    project_id { FactoryGirl.create(:project).id }
    server_id { FactoryGirl.create(:server).id }
    project_instance
    role { ['Web', 'Database', 'Web & Database'].sample }
    stage { ['Staging', 'Production'].sample }
    branch { ['develop', 'master'].sample }
    url Faker::Internet.url
    description Faker::Lorem.paragraph
    closing false

      factory :soft_deleted_installation do
        deleted_at Date.today
      end
  end
end