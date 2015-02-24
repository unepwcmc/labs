# == Schema Information
#
# Table name: installations
#
#  id          :integer          not null, primary key
#  project_id  :integer          not null
#  server_id   :integer          not null
#  role        :string(255)      not null
#  stage       :string(255)      not null
#  branch      :string(255)      not null
#  url         :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Installation < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :project
  belongs_to :server
  belongs_to :project_instance
  
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
