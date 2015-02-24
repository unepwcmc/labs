require 'test_helper'

class InstallationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @installation = FactoryGirl.create(:installation)
    @new_installation = FactoryGirl.build(:installation)
    @soft_deleted_installation = FactoryGirl.create(:soft_deleted_installation)
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
      post :create, installation: { 
        description: @new_installation.description,
        project_instance_id: @new_installation.project_instance_id,
        role: @new_installation.role, server_id: @new_installation.server_id,
      }
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
    patch :update, id: @installation, installation: { 
      description: @installation.description, 
      project_instance_id: @new_installation.project_instance_id,
      role: @installation.role, server_id: @installation.server_id,
    }
    assert_redirected_to installation_path(assigns(:installation))
  end

  test "should destroy installation" do
    assert_difference('Installation.count', -1) do
      delete :destroy, id: @installation
    end

    assert_redirected_to installations_path
  end

  test "should get deleted list" do
    get :deleted_list
    assert_response :success
    assert_not_nil assigns(:installations)
  end

  test "should soft-delete installation" do
    assert_difference('Installation.count', -1) do
      patch :soft_delete, id: @installation, comment:
      {
        content: "Shut down message",
        user_id: @user.id
      }
    end

    assert_equal 2, Installation.only_deleted.count
    assert_equal 1, @installation.comments.count
  end

  test "should restore soft_deleted installation" do
    assert_difference('Installation.count') do
      patch :soft_delete, id: @soft_deleted_installation, comment:
      {
        content: "Restore message",
        user_id: @user.id
      }
    end

    assert_equal 0, Installation.only_deleted.count
  end
end
