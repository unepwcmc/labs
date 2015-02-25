# == Schema Information
#
# Table name: project_instances
#
#  id                 :integer          not null, primary key
#  project_id         :integer          not null
#  name               :string(255)      not null
#  url                :string(255)      not null
#  backup_information :text
#  stage              :string(255)      not null
#  branch             :string(255)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#

class ProjectInstance < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :project
  has_many :installations, dependent: :destroy

  has_many :comments, as: :commentable

  validates :project_id, presence: true

  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |project_instance|
        csv << project_instance.attributes.values_at(*column_names)
      end
    end
  end

  def info
    "<i style='color: #00BFFF'>Description:</i> #{self.description.presence || "-"}<br/><i style='color: #00BFFF'>Backup Information:</i> #{self.backup_information.presence || "-"}"
  end

end
