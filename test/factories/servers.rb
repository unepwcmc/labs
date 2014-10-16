# == Schema Information
#
# Table name: servers
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  domain      :string(255)
#  username    :string(255)
#  admin_url   :string(255)
#  os          :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

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
