require 'test_helper'

class ProjectInstancesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @project_instance = FactoryGirl.create(:project_instance)
    @new_project_instance = FactoryGirl.build(:project_instance)
    @project_instance_with_installations = FactoryGirl.create(:project_instance_with_installations)
    @soft_deleted_project_instance_with_installations = FactoryGirl.create(:soft_deleted_project_instance_with_installations)
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

  test "should get deleted list" do
    get :deleted_list
    assert_response :success
    assert_not_nil assigns(:projects_instances)
  end

  test "should cascade closing flag to installations" do
    patch :update, id: @project_instance_with_installations, project_instance:
      { 
        branch: @new_project_instance.branch, description: @new_project_instance.description, 
        project_id: @new_project_instance.project_id, name: @new_project_instance.name,
        backup_information: @new_project_instance.backup_information,
        stage: @new_project_instance.stage, url: @new_project_instance.url,
        closing: true
      }

    @project_instance_with_installations.installations.each do |installation|
      assert_equal true, installation.closing
    end
  end

  test "should soft-delete project_instance and associated installations" do
    assert_differences([['ProjectInstance.count', -1],['Installation.count', -3]]) do
      patch :soft_delete, id: @project_instance_with_installations, comment:
      {
        content: "Shut down message",
        user_id: @user.id
      }
    end

    assert_equal 2, ProjectInstance.only_deleted.count
    assert_equal 5, Installation.only_deleted.count

    assert_equal 1, @project_instance_with_installations.comments.count

    @project_instance_with_installations.installations.each do |installation|
      assert_equal 1, installation.comments.count
    end
  end

  test "should restore soft-deleted project_instance and associated installations" do

    assert_differences([['ProjectInstance.count', 1],['Installation.count', 2]]) do
      patch :soft_delete, id: @soft_deleted_project_instance_with_installations, comment:
      {
        content: "Restore message",
        user_id: @user.id
      }
    end

    assert_equal 0, ProjectInstance.only_deleted.count
    assert_equal 0, Installation.only_deleted.count
  end
end
