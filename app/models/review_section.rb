class ReviewSection < ActiveRecord::Base
  has_many :questions, class_name: ReviewQuestion, foreign_key: :review_section_id, dependent: :destroy
end
