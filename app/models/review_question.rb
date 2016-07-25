# == Schema Information
#
# Table name: review_questions
#
#  id                :integer          not null, primary key
#  review_section_id :integer          not null
#  code              :text             not null
#  title             :text             not null
#  description       :text
#  sort_order        :integer          default(0), not null
#  skippable         :boolean          default(FALSE)
#  auto_check        :text
#  created_at        :datetime
#  updated_at        :datetime
#

class ReviewQuestion <  ApplicationRecord
  has_many :answers, class_name: ReviewAnswer, foreign_key: :review_question_id, dependent: :destroy
  belongs_to :section, class_name: ReviewSection, foreign_key: :review_section_id
end
