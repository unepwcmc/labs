require 'test_helper'

class ProjectInstancesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @project_instance = FactoryGirl.create(:project_instance)
    @new_project_instance = FactoryGirl.build(:project_instance)
    @project_instance_with_installations = FactoryGirl.create(:project_instance_with_installations)
    @soft_deleted_project_instance_with_installations = FactoryGirl.create(:soft_deleted_project_instance_with_installations)
    @installation = FactoryGirl.build(:installation)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index in html" do
    get :index, format: :html
    assert_response :success
    assert_not_nil assigns(:projects_instances)
  end

  test "sould get index in csv" do
    get :index, format: :csv
    assert_response :success
    assert_equal "text/csv", response.content_type
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_instance" do
    assert_differences([['ProjectInstance.count', 1],['Installation.count', 1]]) do
      post :create, project_instance: { branch: @new_project_instance.branch,
        description: @new_project_instance.description,
        project_id: @new_project_instance.project_id, name: @new_project_instance.name,
        backup_information: @new_project_instance.backup_information,
        stage: @new_project_instance.stage, url: @new_project_instance.url,
        installations_attributes: [{
          server_id: @installation.server_id,
          role: @installation.role,
          description: @installation.description
        }]
      }
    end

    assert_redirected_to "/project_instances/#{ProjectInstance.last.id}"
  end

  test "should generate name for project_instance if not provided" do
    assert_differences([['ProjectInstance.count', 1],['Installation.count', 1]]) do
      post :create, project_instance: { branch: @new_project_instance.branch,
        description: @new_project_instance.description,
        project_id: @new_project_instance.project_id, name: nil,
        backup_information: @new_project_instance.backup_information,
        stage: @new_project_instance.stage, url: @new_project_instance.url,
        installations_attributes: [{
          server_id: @installation.server_id,
          role: @installation.role,
          description: @installation.description
        }]
      }
    end

    project = Project.find(@new_project_instance.project_id)
    assert_equal "#{project.title} (#{@new_project_instance.stage})", ProjectInstance.last.name
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
    installation = @project_instance_with_installations.installations.first
    patch :update, id: @project_instance_with_installations, project_instance:
      {
        branch: @new_project_instance.branch, description: @new_project_instance.description,
        project_id: @new_project_instance.project_id, name: @new_project_instance.name,
        backup_information: @new_project_instance.backup_information,
        stage: @new_project_instance.stage, url: @new_project_instance.url,
        installations_attributes: [{
          id: installation.id,
          server_id: @installation.server_id,
          role: @installation.role,
          description: @installation.description
        }]
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
    stub_slack_comment do
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
  end

  test "should soft-delete project_instance and associated installations" do
    stub_slack_comment do
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
  end

  test "should restore soft-deleted project_instance and associated installations" do
    stub_slack_comment do
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

  test "should get nagios list" do
    stub_request(:get, "https://raw.githubusercontent.com/strtwtsn/strtwtsn.github.io/master/data.tsv").
      to_return(:status => 200, :body => "name\tvalue\napi.speciesplus.net\t100.000\nbern-ors.unep-wcmc.org\t100.000", :headers => {})
    get :nagios_list
    assert_not_nil assigns(:sites)
    assert_response :success
  end

  test "should populate new project_instance" do
    FactoryGirl.create(:project, url: "http://www.google.com")
    url = "google.com"
    get :new, nagios_url: url
    assert_equal Project.last.id, assigns(:project_instance).project_id
    assert_equal url, assigns(:project_instance).url
  end

  test "should add installations" do
    another_installation = FactoryGirl.build(:installation)
    assert_difference("Installation.count", 2) do
      patch :update, id: @project_instance, project_instance:
        {
          installations_attributes: [
            {
              server_id: @installation.server_id,
              role: @installation.role,
              description: @installation.description
            },
            {
              server_id: another_installation.server_id,
              role: another_installation.role,
              description: another_installation.description
            }
          ]
        }
    end
    assert_equal 2, @project_instance.installations.count
  end

  test "should remove installations" do
    installation = @project_instance_with_installations.installations.first
    assert_differences([["Installation.count", -1],["Installation.only_deleted.count", 1]]) do
      patch :update, id: @project_instance_with_installations, project_instance:
        {
          installations_attributes: [
            {
              id: installation.id,
              _destroy: 1
            }
          ]
        }
    end
    assert_equal 2, @project_instance_with_installations.installations.count
  end

end
