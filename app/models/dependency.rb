# == Schema Information
#
# Table name: dependencies
#
#  id                :integer          not null, primary key
#  master_product_id :integer          not null
#  sub_product_id    :integer          not null
#  description       :text
#  created_at        :datetime
#  updated_at        :datetime
#

class Dependency < ApplicationRecord
  belongs_to :master_product, :class_name => "Product"
  belongs_to :sub_product, :class_name => "Product"

  has_many :comments, as: :commentable

  validates :master_product_id, :sub_product_id, presence: true

  def relationship
    "#{self.sub_product.title} <- #{self.master_product.title}"
  end
end
