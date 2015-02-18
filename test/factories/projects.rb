# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  title                 :string(255)      not null
#  description           :text             not null
#  url                   :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published             :boolean          default(FALSE)
#  screenshot            :string(255)
#  github_identifier     :string(255)
#  dependencies          :text
#  state                 :string(255)      not null
#  current_lead          :string(255)
#  hacks                 :text
#  external_clients      :text             default([]), is an Array
#  project_leads         :text             default([]), is an Array
#  developers            :text             default([]), is an Array
#  pdrive_folders        :text             default([]), is an Array
#  dropbox_folders       :text             default([]), is an Array
#  pivotal_tracker_ids   :text             default([]), is an Array
#  trello_ids            :text             default([]), is an Array
#  backup_information    :text
#  expected_release_date :date
#  rails_version         :string(255)
#  ruby_version          :string(255)
#  postgresql_version    :string(255)
#  other_technologies    :text             default([]), is an Array
#  internal_clients      :text             default([]), is an Array
#  internal_description  :text
#

FactoryGirl.define do
  factory :project do
    title Faker::Company.name
    description Faker::Lorem.paragraph
    url Faker::Internet.url
    github_identifier Faker::Internet.url
    state { ['Under Development', 'Delivered', 'Project Development'].sample }
    internal_clients {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    current_lead Faker::Name.name
    external_clients {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    project_leads {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    developers {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    pivotal_tracker_ids {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    trello_ids {[ Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    backup_information Faker::Lorem.paragraph
    expected_release_date {Date.today + Faker::Number.number(3).to_i.days}
    rails_version {Faker::Name.name}
    ruby_version {Faker::Name.name}
    postgresql_version {Faker::Name.name}
    other_technologies {[Faker::Name.name, Faker::Name.name, Faker::Name.name]}
    background_jobs Faker::Lorem.paragraph
    cron_jobs Faker::Lorem.paragraph
    published true

    factory :draft_project do
        published false
    end
  end
end
