# frozen_string_literal: true

require 'test_helper'

class UsersFeaturesTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.build(:user)
    @seed_user = FactoryGirl.create(:user)
  end

  test 'users index page is available to signed in users' do
    sign_in_with_github @user, true
    visit users_path
    page.has_content? @seed_user.email
  end

  test 'users index page is not available to public users' do
    visit users_path
    page.has_content? 'You need to sign in'
  end

  # test "clicking suspend user marks them as suspended in database" do
  #   sign_in_with_github @user, true
  #   visit users_path
  #   assert_not @seed_user.suspended?
  #   first('.user_row').click_link('Suspend') # Any more specific way to find this?
  #   @seed_user.reload
  #   assert @seed_user.suspended?
  # end
end
