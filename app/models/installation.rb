# == Schema Information
#
# Table name: installations
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  server_id   :integer
#  name        :string(255)
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

  #Validations
  validates :project_id, :server_id, :name, :role, :stage, :branch, :url, presence: true
  validates :role, inclusion: { in: ['Web', 'Database', 'Web & Database']}
  validates :stage, inclusion: { in: ['Staging', 'Production']}
  validates :name, uniqueness: true
end
