# == Schema Information
#
# Table name: product_instances
#
#  id                 :integer          not null, primary key
#  product_id         :integer          not null
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
  factory :product_instance do
    product_id { FactoryGirl.create(:product).id }
    stage { ['Staging', 'Production'].sample }
    branch { ['develop', 'master'].sample }
    url Faker::Internet.url
    description Faker::Lorem.paragraph
    name Faker::Company.name
    backup_information Faker::Lorem.paragraph

    factory :product_instance_with_installations do

      transient do
        installations_count 3
      end

      after(:create) do |product_instance, evaluator|
        create_list(
          :installation, evaluator.installations_count,
          product_instance: product_instance
        )
      end
    end

    factory :soft_deleted_product_instance_with_installations do
      deleted_at Date.today

      transient do
        installations_count 2
      end

      after(:create) do |product_instance, evaluator|
        create_list(
          :soft_deleted_installation, evaluator.installations_count,
          product_instance: product_instance
        )
      end
    end
  end

  factory :soft_deleted_product_instance do
    deleted_at Date.today
  end

end
