class ReviewAnswer < ActiveRecord::Base
  belongs_to :review, touch: true
  belongs_to :question, class_name: ReviewQuestion, foreign_key: :review_question_id
  validates :review, presence: true
  validates :question, presence: true

  before_save do |answer|
    if question.auto_check.present?
      answer.selected_option = answer.auto_answer(review.project, question.auto_check.to_sym)
    end
    true
  end

  def auto_answer(project, auto_check_method)
    project.try(auto_check_method)
  end

  def is_acceptable?(question = nil)
    question ||= self.question
    selected_option || skipped && question.skippable
  end

  def is_yes?
    selected_option == true
  end

  def is_no?
    selected_option == false
  end

  def is_skipped?
    skipped
  end

  def as_json(options = { })
    h = super(options)
    h[:is_acceptable] = is_acceptable?
    h
  end
end
