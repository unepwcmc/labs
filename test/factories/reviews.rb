# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  product_id  :integer          not null
#  reviewer_id :integer          not null
#  result      :decimal(, )      not null
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :review do
    reviewer
    product
    result 0
  end

  factory :review_section, aliases: [:section] do
    sequence(:title) { |n| "Section_#{n}" }
    code { |o| o.title }
    sequence(:sort_order) { |n| n }
  end

  factory :review_question, aliases: [:question] do
    sequence(:title) { |n| "Question_#{n}" }
    code { |o| o.title }
    sequence(:sort_order) { |n| n }
    section
    skippable { [true, false].sample }
  end

  factory :review_answer do
    question
    review
    done { [true, false].sample }
  end
end
