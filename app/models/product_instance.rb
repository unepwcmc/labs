# == Schema Information
#
# Table name: product_instances
#
#  id                 :integer          not null, primary key
#  product_id         :integer          not null
#  name               :string(255)      not null
#  url                :string(255)      not null
#  backup_information :text
#  stage              :string(255)      default("Production"), not null
#  branch             :string(255)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#  closing            :boolean          default(FALSE)
#

class ProductInstance < ApplicationRecord
  acts_as_paranoid

  belongs_to :product
  has_many :installations, dependent: :destroy
  has_many :comments, as: :commentable

  validates :product_id, :url, presence: true
  validates :url, format: { with: URI.regexp(%w(http https)) },
    if: Proc.new { |a| a.url.present? }

  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }
  accepts_nested_attributes_for :installations, allow_destroy: true

  after_initialize :init_default_values

  after_update { product.refresh_reviews }

  def init_default_values
    return unless new_record?
    self.stage  ||= 'Production'
    populate_name
  end

  def populate_name
    self.name = "#{product.try(:title)} (#{stage})" if self.name.blank?
  end
end
