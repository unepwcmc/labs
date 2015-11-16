require 'test_helper'

class GithubSyncControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index" do
    stub_request(:get, "#{Rails.application.secrets.github_api_base_url}orgs/unepwcmc/repos?client_id=&client_secret=&page=").
    with(:headers => {'User-Agent'=>'Labs'}).
    to_return(
      :status => 200,
      :body => [{name: 'derp', full_name: "herp", description: 'derp'}].to_json,
      :headers => {
        'link' =>
        """
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?
          client_id=&client_secret=&page=2>; rel='next',
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?
          client_id=&client_secret=&page=3>; rel='last'
        """
      }
    )

    get :index
    assert_response :success
  end

  test "should create a project on post to sync" do
    stub_request(:get, "#{Rails.application.secrets.github_api_base_url}orgs/unepwcmc/repos?client_id=&client_secret=").
    with(:headers => {'User-Agent'=>'Labs'}).
    to_return(
      :status => 200,
      :body => [{"name" => 'derp', "full_name" => "unepwcmc/herp", "description" => 'derp'}].to_json,
      :headers => {
        'link' =>
        """
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?
          client_id=&client_secret=&page=2>; rel='next',
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?
          client_id=&client_secret=&page=3>; rel='last'
        """
      }
    )

    stub_request(:get, "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/first_repo?client_id=&client_secret=").
    with(:headers => {'User-Agent'=>'Labs'}).
    to_return(
      :status => 200,
      :body => {"name" => 'derp', "full_name" => "unepwcmc/herp", "description" => 'derp'}.to_json,
      :headers => {
        'link' =>
        """
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?
          client_id=&client_secret=&page=2>; rel='next',
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?client_id=&client_secret=&page=3>; rel='last'
        """
      }
    )

    assert_difference 'Project.count' do
      post :sync, repos: ["first_repo"]
    end
  end
end
