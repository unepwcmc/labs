require 'test_helper'

class ReviewAnswerTest < ActiveSupport::TestCase
  def setup
    @review = FactoryGirl.create(:review)
    @question = FactoryGirl.create(:review_question)
  end

  def test_updating_answer_updates_result
    assert @review.result == 0.0
    FactoryGirl.create(:review_answer, review: @review, question: @question, done: true)
    assert @review.result == 1.0
  end

  def test_done?
    @answer = FactoryGirl.create(:review_answer, question: @question, done: true)
    assert @answer.done?
    assert !@answer.skipped?
  end
end
