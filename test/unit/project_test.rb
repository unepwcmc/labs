# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  description       :text
#  url               :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  is_dashboard_only :boolean          default(TRUE)
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
