# frozen_string_literal: true

# == Schema Information
#
# Table name: servers
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  domain       :string(255)      not null
#  username     :string(255)
#  admin_url    :string(255)
#  os           :string(255)      not null
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  ssh_key_name :text
#

FactoryGirl.define do
  factory :server do
    sequence(:name) { |n| "Server_#{n}" }
    domain Faker::Internet.url
    username Faker::Internet.user_name
    admin_url Faker::Internet.url
    os { %w[Windows Linux].sample }
    description Faker::Lorem.paragraph
    ssh_key_name Faker::Lorem.paragraph
    open_ports [
      Faker::Number.number(digits: 8),
      Faker::Number.number(digits: 8),
      Faker::Number.number(digits: 8)
    ]
    closing false

    factory :server_with_installations do
      transient do
        installations_count 3
      end

      after(:create) do |server, evaluator|
        create_list(
          :installation, evaluator.installations_count,
          server: server
        )
      end
    end

    factory :soft_deleted_server_with_installations do
      deleted_at Date.today

      transient do
        installations_count 2
      end

      after(:create) do |server, evaluator|
        create_list(
          :soft_deleted_installation, evaluator.installations_count,
          server: server
        )
      end
    end
  end

  factory :soft_deleted_server do
    deleted_at Date.today
  end
end
