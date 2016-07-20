require 'simplecov'
formatters = [SimpleCov::Formatter::HTMLFormatter]
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  formatters.push CodeClimate::TestReporter::Formatter
end
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)
SimpleCov.start 'rails'
SimpleCov.command_name 'test'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'mocha/mini_test'
require 'database_cleaner'
require 'webmock/minitest'

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

  def assert_differences(expression_array, message = nil, &block)
    b = block.send(:binding)
    before = expression_array.map { |expr| eval(expr[0], b) }
    yield

    expression_array.each_with_index do |pair, i|
      e = pair[0]
      difference = pair[1]
      error = "#{e.inspect} didn't change by #{difference}"
      error = "#{message}\n#{error}" if message
      assert_equal(before[i] + difference, eval(e, b), error)
    end
  end

  def stub_slack_comment
    SlackChannel.stub(:post, {:status => 200, :body => "", :headers => {}}) do
      yield
    end
  end
end

OmniAuth.config.test_mode = true
