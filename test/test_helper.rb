ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'mocha/test_unit'
require 'database_cleaner'

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

class ActiveSupport::TestCase
  DatabaseCleaner.strategy = :truncation

  def sign_in_with_github user, is_dev_team
    User.any_instance.stubs(:is_dev_team?).returns(is_dev_team)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => user.provider,
      :uid   => user.uid,
      :info   => {
        :email    => user.email,
        :nickname   => user.github},
      :credentials => {:token => user.token}
    })
    visit root_path
    click_link "Sign in with Github"
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end