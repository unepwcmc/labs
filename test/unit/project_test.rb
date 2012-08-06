# == Schema Information
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  description             :text
#  url                     :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  screenshot_file_name    :string(255)
#  screenshot_content_type :string(255)
#  screenshot_file_size    :integer
#  screenshot_updated_at   :datetime
#  github_id               :string(255)
#  pivotal_tracker_id      :integer
#  toggl_id                :integer
#  deadline                :date
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
