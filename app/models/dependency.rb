# == Schema Information
#
# Table name: dependencies
#
#  id                :integer          not null, primary key
#  master_project_id :integer          not null
#  sub_project_id    :integer          not null
#  description       :text
#  created_at        :datetime
#  updated_at        :datetime
#

class Dependency < ActiveRecord::Base
  belongs_to :master_project, :class_name => "Project"
  belongs_to :sub_project, :class_name => "Project"

  has_many :comments, as: :commentable

  validates :master_project_id, :sub_project_id, presence: true

  def relationship
    "#{self.sub_project.title} <- #{self.master_project.title}"
  end
end
