require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @comment = FactoryGirl.build(:comment)
  end

  test "should have content" do
    assert_not_nil(@comment.content, "Content should not be nil")
  end

end
