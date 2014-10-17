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

require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
