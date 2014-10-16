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
end
