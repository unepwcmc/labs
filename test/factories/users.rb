FactoryGirl.define do
  factory :user do
    provider :github
    uid "7136714"
    email Faker::Internet.email
    github  Faker::Internet.user_name
    password Faker::Internet.password(10, 20)
    token Faker::Code.ean
    factory :suspended_user do
      suspended true
    end
  end
end