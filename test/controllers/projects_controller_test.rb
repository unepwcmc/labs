require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @project = FactoryGirl.build(:project)
    @saved_project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user, name: 'Frodo')

    @project_a = FactoryGirl.create(:project, title: "Abacus", description: "cod", published: false, developers: ['Gandalf', @user.name])
    @project_b = FactoryGirl.create(:project, title: "Beef", description: "cod", developers: ['Aragorn', 'Elbereth'])
    @project_c = FactoryGirl.create(:project, title: "Car", description: "haddock", developers: [@user.name, 'Aragorn'])

    @project_with_instances = FactoryGirl.create(:project_with_instances)
    @project_with_dependencies = FactoryGirl.create(:project_with_dependencies)

    stub_request(:get, Rails.application.secrets.employees_endpoint_url).
    to_return(:status => 200, :body => {"employees" => ['Test','Test']}.to_json,
      :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', :content_type => "application/json"})
  end

  test "should get lists in html" do
    sign_in @user
    get :list, params: { format: :html }
    assert_response :success
    assert_equal assigns(:projects), Project.includes(:project_instances, :reviews).order(:title, 'reviews.updated_at')
  end

  test "should get lists in csv" do
    sign_in @user
    get :list, params: { format: :csv }
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_match /attachment; filename=\"projects.+\.csv\"/, response.headers["Content-Disposition"]
  end

  test "should get combined list in csv" do
    sign_in @user
    get :list, params: { scope: 'combined', format: :csv }
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_match /attachment; filename=\"combined_projects.+\.csv\"/, response.headers["Content-Disposition"]
  end

  test "should return matching public projects on public search" do
    get :index, params: { search: "cod" }
    assert_includes assigns(:projects), @project_b
    assert_not_includes assigns(:projects), @project_a
  end

  test "should return all matching projects on logged in search" do
    sign_in @user
    get :index, params: { search: "cod" }
    assert_includes assigns(:projects), @project_a
    assert_includes assigns(:projects), @project_b
    assert_not_includes assigns(:projects), @project_c
  end

  test "should return all projects on logged in search with no term" do
    sign_in @user
    get :index, params: { search: "" }
    assert_equal assigns(:projects), Project.order('created_at DESC')
  end

  test "should return user's project when in my_projects dashboard" do
    sign_in @user
    get :index, params: {user: @user}

    assert_equal 2, assigns(:projects).count
  end

  test "should return all public projects on public search with no term" do
    get :index, params: { search: "" }
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
    post :create, params: { project: {  title: @project.title,
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
                              expected_release_date: @project.expected_release_date,
                              rails_version: @project.rails_version,
                              ruby_version: @project.ruby_version,
                              postgresql_version: @project.postgresql_version,
                              other_technologies: @project.other_technologies.join(','),
                              background_jobs: @project.background_jobs,
                              cron_jobs: @project.cron_jobs,
                              published: @project.published,
                              master_sub_relationship_attributes: [{
                                master_project_id: @project_with_instances.id
                              }],
                              sub_master_relationshio_attributes: [{
                                sub_project_id: @saved_project.id
                              }]
                            }
                  }
    end
    assert_redirected_to project_path(assigns(:project))
  end

  test "should render new page when failing to create project" do
    sign_in @user
    post :create, params: { project: { url: @project.url } }
    assert_template :new
  end

  test "should show project" do
    sign_in @user
    get :show, params: { id: @saved_project }
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit, params: { id: @saved_project }
    assert_response :success
  end

  test "should update project" do
    sign_in @user
    patch :update, params: { id: @saved_project, project: { title: "New Title" } }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should render edit page when failing to update project" do
    sign_in @user
    patch :update, params: { id: @saved_project, project: { title: "" } }
    assert_template :edit
  end

  test "should destroy project" do
    sign_in @user
    assert_difference('Project.count', -1) do
      delete :destroy, params: { id: @saved_project }
    end
    assert_redirected_to projects_path
  end

  test "should raise exception if deleting project with project instances" do
    sign_in @user
    delete :destroy, params: { id: @project_with_instances.id }

    assert_redirected_to projects_path
    assert_equal "This project has project instances. Delete its project instances first", flash[:alert]
  end

  test "should add dependencies" do
    sign_in @user
    master_project = FactoryGirl.create(:project)
    sub_project = FactoryGirl.create(:project)
    assert_difference("Dependency.count", 2) do
      patch :update, params: { id: @saved_project, project:
        {
          master_sub_relationship_attributes: [
            {
              master_project_id: master_project.id
            }
          ],
          sub_master_relationship_attributes: [
            {
              sub_project_id: sub_project.id
            }
          ]
        }
      }
    end

    assert_equal 1, assigns(:project).master_projects.count
    assert_equal 1, assigns(:project).sub_projects.count
  end

  test "should remove dependencies" do
    sign_in @user
    dependency = Dependency.where(sub_project_id: @project_with_dependencies.id).first
    assert_difference("Dependency.count", -1) do
      patch :update, params: { id: @project_with_dependencies, project:
        {
          master_sub_relationship_attributes: [
            {
              id: dependency.id,
              _destroy: 1
            }
          ]
        }
      }
    end
    assert_equal 0, @project_with_dependencies.master_projects.count
  end

end
