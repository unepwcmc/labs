# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  github                 :string(255)
#  token                  :string(255)
#  suspended              :boolean          default(FALSE)
#  name                   :string(255)
#

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    provider :github
    uid "7136714"
    email
    github  Faker::Internet.user_name
    password Faker::Internet.password(10, 20)
    token Faker::Code.ean
    factory :suspended_user do
      suspended true
    end
  end
end
