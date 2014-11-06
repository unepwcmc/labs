require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @project = FactoryGirl.build(:project)
    @saved_project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)

    @project_a = FactoryGirl.create(:project, title: "Abacus", description: "cod", published: false)
    @project_b = FactoryGirl.create(:project, title: "Beef", description: "cod")
    @project_c = FactoryGirl.create(:project, title: "Car", description: "haddock")

    stub_request(:get, "http://unep-wcmc.org/api/employees.json").
    to_return(:status => 200, :body => {"employees" => ['Test','Test']}.to_json,
      :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', :content_type => "application/json"})
  end

  test "should get lists" do
    sign_in @user
    get :list
    assert_response :success
    assert_equal assigns(:projects), Project.all
  end


  test "should return matching public projects on public search" do
    get :index, search: "cod"
    assert_includes assigns(:projects), @project_b
    assert_not_includes assigns(:projects), @project_a
  end

  test "should return all matching projects on logged in search" do
    sign_in @user
    get :index, search: "cod"
    assert_includes assigns(:projects), @project_a
    assert_includes assigns(:projects), @project_b
    assert_not_includes assigns(:projects), @project_c
  end

  test "should return all projects on logged in search with no term" do
    sign_in @user
    get :index, search: ""
    assert_equal assigns(:projects), Project.order('created_at DESC')
  end

  test "should return all public projects on public search with no term" do
    get :index, search: ""
    assert_equal assigns(:projects), Project.where(published: true).order('created_at DESC')
    assert_not_includes assigns(:projects), @project_a
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
                              url: @project.url,
                              description: @project.description,
                              github_identifier: @project.github_identifier,
                              state: @project.state,
                              internal_clients_array: @project.internal_clients.join(','),
                              current_lead: @project.current_lead,
                              external_clients_array: @project.external_clients.join(','),
                              project_leads_array: @project.project_leads.join(','),
                              developers_array: @project.developers.join(','),
                              pivotal_tracker_ids: @project.pivotal_tracker_ids.join(','),
                              trello_ids: @project.trello_ids.join(','),
                              backup_information: @project.backup_information,
                              expected_release_date: @project.expected_release_date,
                              rails_version: @project.rails_version,
                              ruby_version: @project.ruby_version,
                              postgresql_version: @project.postgresql_version,
                              other_technologies: @project.other_technologies.join(','),
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
