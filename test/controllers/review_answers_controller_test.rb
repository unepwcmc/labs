# frozen_string_literal: true

require 'test_helper'

class ReviewAnswersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @review = FactoryGirl.create(:review)
    @question = FactoryGirl.create(:review_question)
    @answer = FactoryGirl.create(:review_answer, question: @question, review: @review)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test 'should create answer' do
    @another_question = FactoryGirl.create(:review_question)
    assert_difference('ReviewAnswer.count') do
      post :create_or_update, params: {
        review_id: @review.id,
        answer: {
          review_question_id: @another_question.id,
          done: 'yes'
        },
        format: :json
      }
    end
    assert_response :success
  end

  test 'should update answer' do
    assert_no_difference('ReviewAnswer.count') do
      post :create_or_update, params: {
        review_id: @review.id,
        answer: {
          review_question_id: @question.id,
          done: 'no'
        },
        format: :json
      }
    end
    assert_response :success
  end
end
