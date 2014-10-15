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
  # Add pg_search
  include PgSearch

  # Custom search scope for publically viewable projects
  pg_search_scope :search,
    :against => [:title, :description, :repository_url, :state, :internal_client, 
            :current_lead, :external_clients, :project_leads, :developers, 
            :dependencies, :hacks, :pdrive_folders, :dropbox_folders]

  # multisearchable against: [:title, :description, :repository_url, :state, :internal_client, 
  #           :current_lead, :external_clients, :project_leads, :developers, 
  #           :dependencies, :hacks, :pdrive_folders, :dropbox_folders, :published]

  # Validations
  validates :title, :description, :repository_url, :state, :internal_client, 
            :current_lead, :external_clients, :project_leads, :developers, 
              presence: true

  validates :state, inclusion: { in: ['Under Development', 'Delivered', 'Project Development'] }

  # Mount uploader for carrierwave
  mount_uploader :screenshot, ScreenshotUploader

  # Create array getter and setter methods for postgres
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
