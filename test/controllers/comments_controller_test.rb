require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @user = FactoryGirl.create(:user)
    @project_comment = FactoryGirl.create(:project_comment, user_id: @user.id)
    @installation_comment = FactoryGirl.create(:installation_comment, user_id: @user.id)
    @server_comment = FactoryGirl.create(:server_comment, user_id: @user.id)

    sign_in @user
  end

  def assert_formatting comment
    json = JSON.parse(@response.body)
    assert_equal "<p>#{comment.content}</p>\n", json['content']
  end

  def stub_comment
    stub_request(:post, "https://hooks.slack.com/services/T028F7AGY/B040KHJPX/").
    with(:body => { payload: { channel: "#labs", username: "New Comment in #labs", text: "Faker::Lorem", icon_emoji: ":envelope:"
    }.to_json },
         :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => "", :headers => {})
  end

  test "should have content" do
    assert_not_nil(@project_comment.content, "Content should not be nil")
  end

  test "should create project_comment" do
    stub_request(:post, "https://hooks.slack.com/services/T028F7AGY/B040KHJPX/").
    with(:body => "payload=%7B%22channel%22%3A%22%23labs%22%2C%22username%22%3A%22New%20Comment%20in%20%23labs%22%2C%22text%22%3A%22Faker%3A%3ALorem%22%2C%22icon_emoji%22%3A%22%3Aenvelope%3A%22%7D",
         :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => "", :headers => {})


    assert_difference("Comment.count") do
      @response = post :create, comment: {content: @project_comment.content}, user_id: @user, project_id: @project_comment.commentable_id, format: :json
    end
    assert_formatting @project_comment
  end

  test "should create installation_comment" do
    stub_comment
    assert_difference("Comment.count") do
      @response = post :create, comment: {content: @installation_comment.content}, user_id: @user, installation_id: @installation_comment.commentable_id, format: :json
    end
    assert_formatting @installation_comment
  end

  test "should create server_comment" do
    stub_comment
    assert_difference("Comment.count") do
      @response = post :create, comment: {content: @server_comment.content}, user_id: @user, server_id: @server_comment.commentable_id, format: :json
    end
    assert_formatting @server_comment
  end

end
