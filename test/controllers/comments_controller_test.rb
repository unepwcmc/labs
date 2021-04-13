require 'test_helper'
require 'minitest/mock'

class CommentsControllerTest < ActionController::TestCase

  include Devise::Test::ControllerHelpers

  def setup
    @user = FactoryGirl.create(:user)
    @product_comment = FactoryGirl.build(:product_comment, user_id: @user.id)
    @installation_comment = FactoryGirl.build(:installation_comment, user_id: @user.id)
    @server_comment = FactoryGirl.build(:server_comment, user_id: @user.id)

    sign_in @user
  end

  def assert_formatting comment
    json = JSON.parse(@response.body)
    assert_equal "<p>#{comment.content}</p>\n", json['content']
  end

  test "should have content" do
    assert_not_nil(@product_comment.content, "Content should not be nil")
  end

  test "should create product_comment" do
    stub_slack_comment do
      assert_difference("Comment.count") do
        post :create, params: {
                        comment: {
                          content: @product_comment.content
                        },
                        user_id: @user,
                        product_id: @product_comment.commentable_id,
                        format: :json
                      }
      end
      assert_formatting @product_comment
    end
  end

  test "should create installation_comment" do
    stub_slack_comment do
      assert_difference("Comment.count") do
        post :create,  params: {
                         comment: {
                           content: @installation_comment.content
                         },
                         user_id: @user,
                         installation_id: @installation_comment.commentable_id,
                         format: :json
                       }
      end
      assert_formatting @installation_comment
    end
  end

  test "should create server_comment" do
    stub_slack_comment do
      assert_difference("Comment.count") do
        post :create, params: {
                        comment: {
                          content: @server_comment.content
                        },
                        user_id: @user,
                        server_id: @server_comment.commentable_id,
                        format: :json
                      }
      end
      assert_formatting @server_comment
    end
  end

  test "should return error for invalid comment" do
      post :create, params: {
                      comment: {
                        content: ''
                      },
                      user_id: @user,
                      product_id: @product_comment.commentable_id,
                      format: :json
                    }
      assert_response :unprocessable_entity
  end

  test "should destroy comment" do
    comment = FactoryGirl.create(:product_comment, user_id: @user.id)

    stub_slack_comment do
      assert_difference("Comment.count", -1) do
        delete :destroy, params: { id: comment }
      end
      assert_redirected_to products_url
    end
  end

end
