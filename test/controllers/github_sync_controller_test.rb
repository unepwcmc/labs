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

    stub_request(:get, "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/first_repo/contents/Gemfile?client_id=&client_secret=").
    with(:headers => {'User-Agent'=>'Labs'}).
    to_return(
      :status => 200,
      :body => {"name" => 'derp', "full_name" => "unepwcmc/herp", "description" => 'derp', "content" => "encoded content"}.to_json,
      :headers => {
        'link' =>
        """
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?
          client_id=&client_secret=&page=2>; rel='next',
          <#{Rails.application.secrets.github_api_base_url}organizations/513080/repos?client_id=&client_secret=&page=3>; rel='last'
        """
      }
    )

    stub_request(:get, "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/first_repo/contents/.ruby-version?client_id=&client_secret=").
    with(:headers => {'User-Agent'=>'Labs'}).
    to_return(
      :status => 200,
      :body => {"name" => 'derp', "full_name" => "unepwcmc/herp", "description" => 'derp', "content" => "encoded content"}.to_json,
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

  context "push event webhook" do
    setup do
      @project = FactoryGirl.create(:project, {
        title: 'proj',
        github_identifier: 'unepwcmc/repo',
        ruby_version: '1.8',
        rails_version: '3.0'
      })
      GithubSyncController.any_instance.stubs(:verify_signature).returns(true)
      Github.any_instance.stubs(:get_rails_version).returns('4.2')
      Github.any_instance.stubs(:get_ruby_version).returns('2.0')
    end

    should "update project when pushing to master" do
      post :push_event_webhook, {ref: 'head/master', repository: {full_name: 'unepwcmc/repo' } }

      @project.reload
      assert_equal '4.2', @project.rails_version
      assert_equal '2.0', @project.ruby_version
    end

    should "not update project when pushing to branch different from master" do
      post :push_event_webhook, {ref: 'head/branch', repository: {full_name: 'unepwcmc/repo'} }

      @project.reload
      assert_equal '3.0', @project.rails_version
      assert_equal '1.8', @project.ruby_version
    end
  end
end
