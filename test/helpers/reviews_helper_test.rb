# frozen_string_literal: true

require 'test_helper'

class ReviewsHelperTest < ActionView::TestCase
  include ApplicationHelper
  def setup
    @review = FactoryGirl.create(:review)
    @question1 = FactoryGirl.create(:question, skippable: false)
    @question2 = FactoryGirl.create(:question, skippable: false, auto_check: 'production_instance?')
    @question3 = FactoryGirl.create(:question, skippable: true)
    @question4 = FactoryGirl.create(:question)
    @answer_yes = FactoryGirl.create(
      :review_answer,
      review: @review,
      question: @question1,
      done: true,
      skipped: false
    )
    @answer_no = FactoryGirl.create(
      :review_answer,
      review: @review,
      question: @question2,
      done: false,
      skipped: false
    )
    @answer_skipped = FactoryGirl.create(
      :review_answer,
      review: @review,
      question: @question3,
      done: false,
      skipped: true
    )
  end

  def test_answer_for_display_when_yes
    assert_match %r{^<span.*>yes</span>$}, answer_for_display(@question1)
  end

  def test_answer_for_display_when_no
    assert_match %r{^<span.*>no</span>$}, answer_for_display(@question2)
  end

  def test_answer_for_display_when_skipped
    assert_match %r{^<span.*>no</span>$}, answer_for_display(@question3)
  end

  def test_answer_for_display_when_empty
    assert_match %r{^<span.*>\(empty\)</span>$}, answer_for_display(@question4)
  end

  def test_review_input_group_when_not_skippable_checked_enabled
    actual = review_input_group(@question1)
    assert_match /checked=\"checked\"/, actual
    assert_no_match /disabled=\"disabled\"/, actual
    assert_match /type=\"checkbox\"/, actual
  end

  def test_review_input_group_when_not_skippable_not_checked_disabled
    actual = review_input_group(@question2)
    assert_no_match /checked=\"checked\"/, actual
    assert_match /disabled=\"disabled\"/, actual
    assert_match /type=\"checkbox\"/, actual
  end

  def test_review_input_group_when_skippable_not_checked_enabled
    actual = review_input_group(@question3)
    assert_no_match /disabled=\"disabled\"/, actual
    assert_match /type=\"radio\"/, actual
  end

  def test_feedback_success
    actual = feedback(@question1)
    assert_match /feedback success/, actual
  end

  def test_feedback_error
    actual = feedback(@question2)
    assert_match /feedback error/, actual
  end
end
