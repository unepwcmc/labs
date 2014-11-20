# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  title                 :string(255)      not null
#  description           :text             not null
#  url                   :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published             :boolean          default(FALSE)
#  screenshot            :string(255)
#  github_identifier     :string(255)
#  dependencies          :text
#  state                 :string(255)      not null
#  current_lead          :string(255)
#  hacks                 :text
#  external_clients      :text             default([]), is an Array
#  project_leads         :text             default([]), is an Array
#  developers            :text             default([]), is an Array
#  pdrive_folders        :text             default([]), is an Array
#  dropbox_folders       :text             default([]), is an Array
#  pivotal_tracker_ids   :text             default([]), is an Array
#  trello_ids            :text             default([]), is an Array
#  backup_information    :text
#  expected_release_date :date
#  rails_version         :string(255)
#  ruby_version          :string(255)
#  postgresql_version    :string(255)
#  other_technologies    :text             default([]), is an Array
#  internal_clients      :text             default([]), is an Array
#  internal_description  :text
#

class Project < ActiveRecord::Base
  # Add pg_search
  include PgSearch

  # Relationships
  has_many :installations
  has_many :projects, through: :installation
  has_many :comments, as: :commentable

  has_many :master_sub_relationship, :foreign_key => 'sub_project_id',
    :class_name => 'Dependency', :dependent => :destroy
  has_many :master_projects, :through => :master_sub_relationship

  has_many :sub_master_relationship, :foreign_key => 'master_project_id',
    :class_name => 'Dependency', :dependent => :destroy
  has_many :sub_projects, :through => :sub_master_relationship

  # Custom search scope for publically viewable projects
  pg_search_scope :search, :using => { :tsearch => {:prefix => true} },
    :against => [:title, :description, :github_identifier, :state, :internal_clients,
            :current_lead, :external_clients, :project_leads, :developers,
            :dependencies, :hacks, :pdrive_folders, :dropbox_folders,
            :pivotal_tracker_ids, :trello_ids, :expected_release_date, :backup_information,
            :rails_version, :ruby_version, :postgresql_version, :other_technologies]

  scope :published, -> { where(published: true) }

  # multisearchable against: [:title, :description, :github_identifier, :state, :internal_clients,
  #           :current_lead, :external_clients, :project_leads, :developers, 
  #           :dependencies, :hacks, :pdrive_folders, :dropbox_folders, :published]

  # Validations
  validates :title, :description, :state, presence: true
  validates :url, if: :published, presence: true

  validates :state, inclusion: { in: ['Under Development', 'Delivered', 'Project Development', 'Discontinued'] }

  # Mount uploader for carrierwave
  mount_uploader :screenshot, ScreenshotUploader

  # Create array getter and setter methods for postgres
  ["developers","internal_clients","external_clients","project_leads","pdrive_folders","dropbox_folders",
    "pivotal_tracker_ids","trello_ids","other_technologies"].each do |attribute|
  	define_method("#{attribute}_array") do
  		self.send(attribute).join(',')
  	end

  	define_method("#{attribute}_array=") do |params|
      self.send("#{attribute}=", params.split(','))
      self.send(:save)
  	end
  end

end
