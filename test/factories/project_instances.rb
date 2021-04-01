# frozen_string_literal: true

# == Schema Information
#
# Table name: project_instances
#
#  id                 :integer          not null, primary key
#  project_id         :integer          not null
#  name               :string(255)      not null
#  url                :string(255)      not null
#  backup_information :text
#  stage              :string(255)      default("Production"), not null
#  branch             :string(255)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#  closing            :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :project_instance do
    project_id { FactoryGirl.create(:project).id }
    stage { %w[Staging Production].sample }
    branch { %w[develop master].sample }
    url Faker::Internet.url
    description Faker::Lorem.paragraph
    name Faker::Company.name
    backup_information Faker::Lorem.paragraph

    factory :project_instance_with_installations do
      transient do
        installations_count 3
      end

      after(:create) do |project_instance, evaluator|
        create_list(
          :installation, evaluator.installations_count,
          project_instance: project_instance
        )
      end
    end

    factory :soft_deleted_project_instance_with_installations do
      deleted_at Date.today

      transient do
        installations_count 2
      end

      after(:create) do |project_instance, evaluator|
        create_list(
          :soft_deleted_installation, evaluator.installations_count,
          project_instance: project_instance
        )
      end
    end
  end

  factory :soft_deleted_project_instance do
    deleted_at Date.today
  end
end
