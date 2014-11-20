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
    os { ['Windows', 'Linux'].sample }
    description Faker::Lorem.paragraph
    ssh_key_name Faker::Lorem.paragraph
  end
end
