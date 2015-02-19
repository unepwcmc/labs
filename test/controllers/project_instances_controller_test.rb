require 'test_helper'

class ProjectInstancesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @project_instance = FactoryGirl.create(:project_instance)
    @new_project_instance = FactoryGirl.build(:project_instance)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_instance" do
    assert_difference('ProjectInstance.count') do
      post :create, project_instance: { branch: @new_project_instance.branch,
        description: @new_project_instance.description, 
        project_id: @new_project_instance.project_id, name: @new_project_instance.name,
        backup_information: @new_project_instance.backup_information,
        stage: @new_project_instance.stage, url: @new_project_instance.url
      }
    end

    assert_redirected_to "/project_instances/#{ProjectInstance.last.id}"
  end

  test "should show project_instance" do
    get :show, id: @project_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_instance
    assert_response :success
  end

  test "should update project_instance" do
    patch :update, id: @project_instance, project_instance:
      { 
        branch: @new_project_instance.branch, description: @new_project_instance.description, 
        project_id: @new_project_instance.project_id, name: @new_project_instance.name,
        backup_information: @new_project_instance.backup_information,
        stage: @new_project_instance.stage, url: @new_project_instance.url
      }
    assert_redirected_to project_instance_path(assigns(:project_instance))
  end

  test "should destroy project_instance" do
    assert_difference('ProjectInstance.count', -1) do
      delete :destroy, id: @project_instance
    end

    assert_redirected_to project_instances_path
  end
end
