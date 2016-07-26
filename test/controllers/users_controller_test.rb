require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @user = FactoryGirl.create(:user)
  end

  test "logged in user should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "public user should be redirected" do
    get :index
    assert_response :redirect
  end

  test "user should be suspended when suspend action is called" do
    sign_in @user
    another_user = FactoryGirl.create(:user)
    patch :suspend, params: { id: another_user }
    assert_equal true, another_user.reload.suspended
    assert_redirected_to root_path
  end
end
