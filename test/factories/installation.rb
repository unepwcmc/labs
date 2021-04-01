# frozen_string_literal: true

FactoryGirl.define do
  factory :installation do
    server_id { FactoryGirl.create(:server).id }
    project_instance
    role { ['Web', 'Database', 'Web & Database'].sample }
    description Faker::Lorem.paragraph
    closing false

    factory :soft_deleted_installation do
      deleted_at Date.today
    end
  end
end
