require 'test_helper'

class SignInWithGithubTest < ActionDispatch::IntegrationTest
  def setup
  	OmniAuth.config.test_mode = true
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
    sign_in_with_github @user, true
    assert page.has_content? "Your account has been suspended"
  end
end
