# frozen_string_literal: true

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
#  deleted_at          :datetime
#  closing             :boolean          default(FALSE)
#

require 'test_helper'

class InstallationTest < ActiveSupport::TestCase
  should validate_presence_of :server_id
  should validate_presence_of :role

  should validate_inclusion_of(:role).in_array(['Web', 'Database', 'Web & Database'])
end
