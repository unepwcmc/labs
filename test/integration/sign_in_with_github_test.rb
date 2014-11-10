require 'test_helper'

class SignInWithGithubTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.build(:user)
  end

  test "member of wcmc-core-dev team signs in with github" do
    sign_in_with_github @user, true
    assert page.has_content? "Signed in as: #{@user.github}"
  end

  test "does not log in with valid user that is not a member of the wcmc-core-dev group" do
    sign_in_with_github @user, false
    assert page.has_content? "You need to be a member of the wcmc-core-dev group on github to be authorized to access this page."
  end

  test "does not log in suspended user" do
    @user = FactoryGirl.create(:suspended_user)
    stub_request(:get, "https://api.github.com/users/#{@user.github}?access_token=#{@user.token}").
      to_return(:status => 200, :body => {"test" => 'Test'}.to_json, :headers => {'Accept'=>'*/*', 'User-Agent'=>'Labs',
        :content_type => "application/json"})

    sign_in_with_github @user, true
    assert page.has_content? "Your account has been suspended"
  end
end
