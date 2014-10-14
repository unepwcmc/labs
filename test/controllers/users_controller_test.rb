require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "logged in user should get index" do
    @user = FactoryGirl.create(:user)
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "public user should be redirected" do
    get :index
    assert_response :redirect
  end
end
