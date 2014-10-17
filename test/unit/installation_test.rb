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

require 'test_helper'

class InstallationTest < ActiveSupport::TestCase
  should validate_presence_of :project_id
  should validate_presence_of :server_id
  should validate_presence_of :name
  should validate_presence_of :role
  should validate_presence_of :stage
  should validate_presence_of :branch
  should validate_presence_of :url

  should validate_inclusion_of(:role).in_array(['Web', 'Database', 'Web & Database'])
  should validate_inclusion_of(:stage).in_array(['Staging', 'Production'])
  should validate_uniqueness_of :name

end
