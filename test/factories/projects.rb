# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :text
#  url              :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  published        :boolean          default(FALSE)
#  screenshot       :string(255)
#  repository_url   :string(255)
#  dependencies     :text
#  state            :string(255)
#  internal_client  :string(255)
#  current_lead     :string(255)
#  hacks            :text
#  external_clients :text             default([]), is an Array
#  project_leads    :text             default([]), is an Array
#  developers       :text             default([]), is an Array
#  pdrive_folders   :text             default([]), is an Array
#  dropbox_folders  :text             default([]), is an Array
#

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
