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

require 'test_helper'

class InstallationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
