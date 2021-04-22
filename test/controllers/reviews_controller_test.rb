require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @product = FactoryGirl.create(:product)
    @review = FactoryGirl.create(:review, product: @product)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create review" do
    assert_difference('Review.count') do
      post :create, params: {
        review: {
          reviewer_id: @user.id,
          product_id: FactoryGirl.create(:product).id
        }
      }
    end
    assert_redirected_to edit_review_path(assigns(:review))
  end

  test "should not create review" do
    assert_no_difference('Review.count') do
      post :create, params: {
        review: {
          reviewer_id: @user.id,
          product_id: nil
        }
      }
    end
    assert_response :success
  end

  test "should show review" do
    get :show, params: { id: @review }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @review }
    assert_response :success
  end

  test "should update review" do
    put :update, params: {
      id: @review.id,
      review: {
        reviewer_id: @user.id,
        product_id: FactoryGirl.create(:product).id
      }
    }
    assert_redirected_to review_path(assigns(:review))
  end

  test "should not update review" do
    put :update, params: {
      id: @review.id,
      review: {
        reviewer_id: @user.id,
        product_id: nil
      }
    }
    assert @review.product_id == @product.id
    assert_response :success
  end

  test "should destroy review" do
    assert_difference('Review.count', -1) do
      delete :destroy, params: { id: @review }
    end

    assert_redirected_to reviews_path
  end
end
