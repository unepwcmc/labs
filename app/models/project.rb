# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :text
#  url              :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  published        :boolean          default(FALSE)
#  screenshot       :string(255)
#  repository_url   :string(255)
#  dependencies     :text
#  state            :string(255)
#  internal_client  :string(255)
#  current_lead     :string(255)
#  hacks            :text
#  external_clients :string(255)
#  project_leads    :string(255)
#  developers       :string(255)
#  pdrive_folders   :string(255)
#  dropbox_folders  :string(255)
#

class Project < ActiveRecord::Base
  mount_uploader :screenshot, ScreenshotUploader

  ["developers","external_clients","project_leads","pdrive_folders","dropbox_folders"].each do |attribute|
  	define_method("#{attribute}_array") do
  		self.send(attribute).join(',')
  	end

  	define_method("#{attribute}_array=") do |params|
      self.send("#{attribute}=", params.split(','))
      self.send(:save)
  	end
  end
end
