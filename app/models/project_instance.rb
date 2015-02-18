class ProjectInstance < ActiveRecord::Base
  belongs_to :project
  has_many :installations

  validates :project_id, presence: true
end
