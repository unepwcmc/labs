# == Schema Information
#
# Table name: installations
#
#  id                  :integer          not null, primary key
#  server_id           :integer          not null
#  role                :string(255)      not null
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  project_instance_id :integer          not null
#

class Installation < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :server
  belongs_to :project_instance
  has_many :comments, as: :commentable

  #Validations
  validates :server_id, :role, presence: true
  validates :role, inclusion: { in: ['Web', 'Database', 'Web & Database']}

  delegate :stage, to: :project_instance
  delegate :project, to: :project_instance

  def name
    "#{self.project.title} - #{role} (#{stage})"
  end

end
