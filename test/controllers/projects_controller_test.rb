require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @project = FactoryGirl.build(:project)
    @saved_project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should create project" do
    sign_in @user
    assert_difference('Project.count') do
    post :create, project: {  title: @project.title,
                              description: @project.description,
                              repository_url: @project.repository_url,
                              state: @project.state,
                              internal_client: @project.internal_client,
                              current_lead: @project.current_lead,
                              external_clients_array: @project.external_clients.join(','),
                              project_leads_array: @project.project_leads.join(','),
                              developers_array: @project.developers.join(','),
                              published: @project.published
                            }
    end
    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    sign_in @user
    get :show, id: @saved_project
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit, id: @saved_project
    assert_response :success
  end

  test "should update project" do
    sign_in @user
    patch :update, id: @saved_project, project: { title: "New Title" }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    sign_in @user
    assert_difference('Project.count', -1) do
      delete :destroy, id: @saved_project
    end
    assert_redirected_to projects_path
  end
end