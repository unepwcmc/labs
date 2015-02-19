require 'test_helper'

class GithubSyncControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index" do
    stub_request(:get, "https://api.github.com/orgs/unepwcmc/repos").
    to_return(:status => 200, :body => [{name: 'derp', description: 'derp'}].to_json) 

    get :index
    assert_response :success
  end

  test "should create a project on post to sync" do
    stub_request(:get, "https://api.github.com/repos/unepwcmc/first_repo").
    to_return(:status => 200, :body => {"name" => 'derp', "description" => 'derp'}.to_json) 

    assert_difference 'Project.count' do
      post :sync, repos: ["first_repo"]
    end
  end
end
