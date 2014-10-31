FactoryGirl.define do

  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  factory :comment do
    content Faker::Lorem.name
  end

  factory :project_comment, class: "Comment" do
    content Faker::Lorem.name
    user_id { FactoryGirl.build(:user).id }
    association :commentable, factory: :project
  end

  factory :installation_comment, class: "Comment" do
    content Faker::Lorem.name
    user_id { FactoryGirl.build(:user).id }
    association :commentable, factory: :installation
  end

  factory :server_comment, class: "Comment" do
    content Faker::Lorem.name
    user_id { FactoryGirl.build(:user).id }
    association :commentable, factory: :server
  end
end