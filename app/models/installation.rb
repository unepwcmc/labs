# == Schema Information
#
# Table name: installations
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  server_id   :integer
#  role        :string(255)
#  stage       :string(255)
#  branch      :string(255)
#  url         :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Installation < ActiveRecord::Base
  belongs_to :project
  belongs_to :server

  has_many :comments, as: :commentable

  #Validations
  validates :project_id, :server_id, :role, :stage, :branch, presence: true
  validates :url, presence: true, if: lambda { |installation| installation.role != "Database"}
  validates :role, inclusion: { in: ['Web', 'Database', 'Web & Database']}
  validates :stage, inclusion: { in: ['Staging', 'Production']}

  def name
    "#{self.project.title}_#{role}_#{stage}"
  end
end
