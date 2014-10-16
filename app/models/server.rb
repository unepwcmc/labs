# == Schema Information
#
# Table name: servers
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  domain      :string(255)
#  username    :string(255)
#  admin_url   :string(255)
#  os          :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Server < ActiveRecord::Base
  has_many :installations
  has_many :projects, through: :installations
end
