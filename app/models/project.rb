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
#  screenshot        :string(255)
#

class Project < ActiveRecord::Base
  mount_uploader :screenshot, ScreenshotUploader
end
