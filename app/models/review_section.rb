# == Schema Information
#
# Table name: review_sections
#
#  id         :integer          not null, primary key
#  code       :text             not null
#  title      :text             not null
#  sort_order :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class ReviewSection < ApplicationRecord
  has_many :questions, class_name: ReviewQuestion, foreign_key: :review_section_id, dependent: :destroy
end
