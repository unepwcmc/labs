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
#  open_ports   :text             default([]), is an Array
#  closing      :boolean          default(FALSE)
#

class Server <  ApplicationRecord
  acts_as_paranoid

  has_many :installations, dependent: :destroy
  has_many :comments, as: :commentable

  #Validations
  validates :name, :domain, :os, presence: true

  validates :os, inclusion: { in: ['Windows', 'Linux'] }
  validates :name, uniqueness: true

  def open_ports_array
    open_ports.join(',')
  end

  def open_ports_array=(value)
    self.open_ports = value.split(',')
    save
  end
end
