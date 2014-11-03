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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#  github                 :string(255)
#  token                  :string(255)
#  suspended              :boolean          default(FALSE)
#

require 'test_helper'
require 'json'

class UserTest < ActiveSupport::TestCase
  test "is_dev_team? method" do
    WebMock.disable_net_connect!(allow_localhost: true)
    @user = FactoryGirl.build(:user)
    stub_request(:get, "https://api.github.com/teams/98845/memberships/#{@user.github}?access_token=#{@user.token}").
      with(:headers => {'User-Agent'=>'Labs'}).
      to_return(:status => 200, :body => {:state => 'active'}.to_json, :headers => {})
    assert_equal(true, @user.is_dev_team?)
    WebMock.allow_net_connect!
  end
end
