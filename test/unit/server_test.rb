# == Schema Information
#
# Table name: servers
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  domain       :string(255)
#  username     :string(255)
#  admin_url    :string(255)
#  os           :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  ssh_key_name :text
#

require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  should validate_presence_of :name
  should validate_presence_of :domain
  should validate_presence_of :os
  
  should validate_inclusion_of(:os).in_array(['Windows', 'Linux'])
  should validate_uniqueness_of :name
end
