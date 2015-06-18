class ReviewAnswer < ActiveRecord::Base
  belongs_to :review
  belongs_to :question, class_name: ReviewQuestion, foreign_key: :review_question_id
  validates :review, presence: true
  validates :question, presence: true

  before_save do |answer|
    if question.auto_check.present?
      answer.selected_option = answer.auto_answer(review.project, question.auto_check.to_sym)
    end
    true
  end

  after_save { review.respond_to_answer_update }

  def auto_answer(project, auto_check_method)
    project.try(auto_check_method)
  end

  def is_acceptable?(question = nil)
    question ||= self.question
    done? || skipped? && question.skippable
  end

  def done?
    selected_option == true
  end

  def as_json(options = { })
    h = super(options)
    h[:is_acceptable] = is_acceptable?
    h
  end
end
