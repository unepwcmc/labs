# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text             not null
#  commentable_id   :integer          not null
#  commentable_type :string(255)      not null
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer          not null
#

FactoryGirl.define do

  before(:create) do
  end

  factory :comment do
    content Faker::Lorem.name
    user_id { FactoryGirl.create(:user).id }
  end

  factory :product_comment, class: "Comment" do
    content Faker::Lorem.name
    user_id { FactoryGirl.create(:user).id }
    association :commentable, factory: :product
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
