class Project < ActiveRecord::Base
  has_attached_file :screenshot, :styles => { :medium => "280x200>", :thumb => "100x100>" }
end
# == Schema Information
#
# Table name: projects
#
#  id                      :integer         not null, primary key
#  title                   :string(255)
#  description             :text
#  url                     :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  screenshot_file_name    :string(255)
#  screenshot_content_type :string(255)
#  screenshot_file_size    :integer
#  screenshot_updated_at   :datetime
#

