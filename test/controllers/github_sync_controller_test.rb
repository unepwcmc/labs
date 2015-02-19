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

  # test "should get sync" do
  #   stub_request(:get, "https://api.github.com/repos/unepwcmc/*").
  #   to_return(:status => 200, :body => [{name: 'derp', description: 'derp'}].to_json) 

  #   get :sync, repo: ["first_repo", "second_repo"]
  #   assert_response :success
  # end

end
