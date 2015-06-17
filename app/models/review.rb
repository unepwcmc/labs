class Review < ActiveRecord::Base
  belongs_to :project
  belongs_to :reviewer, class_name: User, foreign_key: :reviewer_id
  has_many :answers, class_name: ReviewAnswer, foreign_key: :review_id, dependent: :destroy
  has_many :comments, as: :commentable
  validates :project, presence: true
  validates :reviewer, presence: true

  before_save do |review|
    review.result = review.recalculate_result
  end
  after_touch do |review|
    update_column(:result, review.recalculate_result)
  end
  after_create do |review|
    auto_answer_questions
  end

  # find answer to corresponding question within an already fetched
  # collection of answers
  def answer(question)
    answers.find{ |a| a.review_question_id == question.id }
  end

  def result_formatted
    "#{(result * 100).round}%"
  end

  def auto_answer_questions
    ReviewSection.all.each do |section|
      section.questions.where('auto_check IS NOT NULL').each do |question|
        answer = self.answers.where(review_question_id: question.id).first
        answer ||= self.answers.build(review_question_id: question.id)
        answer.selected_option = answer.auto_answer(project, question.auto_check.to_sym)
        answer.save!
      end
    end
  end

  protected

  def recalculate_result
    fetched_answers = answers.preload(:question).all # force fetch
    questions_count = ReviewQuestion.count
    if questions_count == 0
      0
    else
      accepted_answers_count = fetched_answers.select{ |a| a.is_acceptable? }.size
      accepted_answers_count.to_f / questions_count
    end
  end

end
