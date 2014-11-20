# == Schema Information
#
# Table name: servers
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  domain       :string(255)      not null
#  username     :string(255)
#  admin_url    :string(255)
#  os           :string(255)      not null
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  ssh_key_name :text
#

class Server < ActiveRecord::Base
  has_many :installations, dependent: :destroy
  has_many :projects, through: :installations
  has_many :comments, as: :commentable

  #Validations
  validates :name, :domain, :os, presence: true
  
  validates :os, inclusion: { in: ['Windows', 'Linux'] }
  validates :name, uniqueness: true
end
