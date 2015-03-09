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

  test "should have content" do
    assert_not_nil(@project_comment.content, "Content should not be nil")
  end

  test "should create project_comment" do
    assert_difference("Comment.count") do
      @response = post :create, comment: {content: @project_comment.content}, user_id: @user, project_id: @project_comment.commentable_id, format: :json
    end
    assert_formatting @project_comment
  end

  test "should create installation_comment" do
    assert_difference("Comment.count") do
      @response = post :create, comment: {content: @installation_comment.content}, user_id: @user, installation_id: @installation_comment.commentable_id, format: :json
    end
    assert_formatting @installation_comment
  end

  test "should create server_comment" do
    assert_difference("Comment.count") do
      @response = post :create, comment: {content: @server_comment.content}, user_id: @user, server_id: @server_comment.commentable_id, format: :json
    end
    assert_formatting @server_comment
  end

end
