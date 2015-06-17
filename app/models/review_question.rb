class ReviewQuestion < ActiveRecord::Base
  has_many :answers, class_name: ReviewAnswer, foreign_key: :review_question_id, dependent: :destroy
  belongs_to :section, class_name: ReviewSection, foreign_key: :review_section_id
end
