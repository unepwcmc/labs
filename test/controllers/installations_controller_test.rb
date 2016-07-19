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
    get :index, params: { format: :csv }
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_match /attachment; filename=\"installations.+\.csv\"/, response.headers["Content-Disposition"]
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create installation" do
    assert_difference('Installation.count') do
      post :create, params: {
        installation: {
          description: @new_installation.description,
          project_instance_id: @new_installation.project_instance_id,
          role: @new_installation.role, server_id: @new_installation.server_id,
        }
      }
    end

    assert_redirected_to installations_path
  end

  test "should show installation" do
    get :show, params: { id: @installation }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @installation }
    assert_response :success
  end

  test "should update installation" do
    patch :update, params: { id: @installation, installation: {
      description: @installation.description,
      project_instance_id: @new_installation.project_instance_id,
      role: @installation.role, server_id: @installation.server_id,
      }
    }
    assert_redirected_to installation_path(assigns(:installation))
  end

  test "should send a notification when closing installation" do
    message = "*#{@installation.name}* installation has been scheduled for close down"
    SlackChannel.expects(:post).with("#labs", "Labs detective (test)", message, ":squirrel:")
    patch :update, params: { id: @installation, installation: {
        closing: true
      }
    }
    assert_redirected_to installation_path(assigns(:installation))
  end

  test "should send a notification when re-opening installation" do
    installation = FactoryGirl.create(:installation, {closing: true})
    message = "*#{installation.name}* installation has been unscheduled for close down"
    SlackChannel.expects(:post).with("#labs", "Labs detective (test)", message, ":squirrel:")
    patch :update, params: { id: installation, installation: {
        closing: false
      }
    }
    assert_redirected_to installation_path(assigns(:installation))
  end

  test "should destroy installation" do
    assert_difference('Installation.count', -1) do
      delete :destroy, params: { id: @installation }
    end

    assert_redirected_to installations_path
  end

  test "should get deleted list" do
    get :deleted_list
    assert_response :success
    assert_not_nil assigns(:installations)
  end

  test "should soft-delete installation" do
    stub_slack_comment do
      assert_difference('Installation.count', -1) do
        patch :soft_delete, params: { id: @installation, comment:
          {
            content: "Shut down message",
            user_id: @user.id
          }
        }
      end

      assert_equal 2, Installation.only_deleted.count
      assert_equal 1, @installation.comments.count
    end
  end

  test "should restore soft_deleted installation" do
    stub_slack_comment do
      assert_difference('Installation.count') do
        patch :soft_delete, params: { id: @soft_deleted_installation, comment:
          {
            content: "Restore message",
            user_id: @user.id
          }
        }
      end

      assert_equal 0, Installation.only_deleted.count
    end
  end

end
