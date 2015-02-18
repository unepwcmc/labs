class ProjectInstance < ActiveRecord::Base
  belongs_to :project
  has_many :installations

  has_many :comments, as: :commentable

  validates :project_id, presence: true
end
