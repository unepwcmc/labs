require 'test_helper'

class InstallationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @installation = FactoryGirl.create(:installation)
    @new_installation = FactoryGirl.build(:installation)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:installations)
  end

  test "should get index in csv" do
    get :index, format: :csv
    assert_response :success
    assert_equal "text/csv", response.headers['Content-Type']
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create installation" do
    assert_difference('Installation.count') do
      post :create, installation: { branch: @new_installation.branch, description: @new_installation.description, project_id: @new_installation.project_id, role: @new_installation.role, server_id: @new_installation.server_id, stage: @new_installation.stage, url: @new_installation.url }
    end

    assert_redirected_to installations_path
  end

  test "should show installation" do
    get :show, id: @installation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @installation
    assert_response :success
  end

  test "should update installation" do
    patch :update, id: @installation, installation: { branch: @installation.branch, description: @installation.description, project_id: @installation.project_id, role: @installation.role, server_id: @installation.server_id, stage: @installation.stage, url: @installation.url }
    assert_redirected_to installation_path(assigns(:installation))
  end

  test "should destroy installation" do
    assert_difference('Installation.count', -1) do
      delete :destroy, id: @installation
    end

    assert_redirected_to installations_path
  end
end
