require 'test_helper'

class ReviewAnswerTest < ActiveSupport::TestCase
  def test_updating_answer_updates_result
    @review = FactoryGirl.create(:review)
    assert @review.result == 0.0
    @question = FactoryGirl.create(:review_question)
    FactoryGirl.create(:review_answer, review: @review, question: @question, selected_option: true)
    assert @review.result == 1.0
  end
end
