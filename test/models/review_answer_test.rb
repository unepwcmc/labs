# frozen_string_literal: true

# == Schema Information
#
# Table name: review_answers
#
#  id                 :integer          not null, primary key
#  review_id          :integer          not null
#  review_question_id :integer          not null
#  done               :boolean          default(FALSE), not null
#  skipped            :boolean          default(FALSE), not null
#  created_at         :datetime
#  updated_at         :datetime
#

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
