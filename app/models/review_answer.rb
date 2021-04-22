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

class ReviewAnswer < ApplicationRecord
  belongs_to :review
  belongs_to :question, class_name: ReviewQuestion, foreign_key: :review_question_id
  validates :review, presence: true
  validates :question, presence: true

  before_save do |answer|
    if question.auto_check.present?
      answer.done = answer.auto_answer(review.product, question.auto_check.to_sym)
    end
    true
  end

  after_save { review.respond_to_answer_update }

  def auto_answer(product, auto_check_method)
    product.try(auto_check_method) || false
  end

  def is_acceptable?(question = nil)
    question ||= self.question
    done? || skipped? && question.skippable
  end

  def as_json(options = { })
    h = super(options)
    h[:is_acceptable] = is_acceptable?
    h
  end
end
