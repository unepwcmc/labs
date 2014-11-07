# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#

FactoryGirl.define do

  before(:create) do
  end

  factory :comment do
    content Faker::Lorem.name
    user_id { FactoryGirl.create(:user).id }
  end

  factory :project_comment, class: "Comment" do
    content Faker::Lorem.name
    user_id { FactoryGirl.create(:user).id }
    association :commentable, factory: :project
  end

  factory :installation_comment, class: "Comment" do
    content Faker::Lorem.name
    user_id { FactoryGirl.create(:user).id }
    association :commentable, factory: :installation
  end

  factory :server_comment, class: "Comment" do
    content Faker::Lorem.name
    user_id { FactoryGirl.create(:user).id }
    association :commentable, factory: :server
  end
end
