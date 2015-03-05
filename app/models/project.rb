# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  title                 :string(255)      not null
#  description           :text             not null
#  url                   :string(255)
#  created_at            :datetime
#  updated_at            :datetime
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
#  expected_release_date :date
#  rails_version         :string(255)
#  ruby_version          :string(255)
#  postgresql_version    :string(255)
#  other_technologies    :text             default([]), is an Array
#  internal_clients      :text             default([]), is an Array
#  internal_description  :text
#  background_jobs       :text
#  cron_jobs             :text
#

class Project < ActiveRecord::Base
  # Add pg_search
  include PgSearch

  # Relationships
  has_many :comments, as: :commentable

  has_many :master_sub_relationship, :foreign_key => 'sub_project_id',
    :class_name => 'Dependency', :dependent => :destroy
  has_many :master_projects, :through => :master_sub_relationship

  has_many :sub_master_relationship, :foreign_key => 'master_project_id',
    :class_name => 'Dependency', :dependent => :destroy
  has_many :sub_projects, :through => :sub_master_relationship

  has_many :project_instances

  # Custom search scope for publically viewable projects
  pg_search_scope :search, :using => { :tsearch => {:prefix => true} },
    :against => [:title, :description, :github_identifier, :state, :internal_clients,
            :current_lead, :external_clients, :project_leads, :developers,
            :dependencies, :hacks, :pdrive_folders, :dropbox_folders,
            :pivotal_tracker_ids, :trello_ids, :expected_release_date,
            :rails_version, :ruby_version, :postgresql_version, :other_technologies]

  scope :published, -> { where(published: true) }

  # multisearchable against: [:title, :description, :github_identifier, :state, :internal_clients,
  #           :current_lead, :external_clients, :project_leads, :developers, 
  #           :dependencies, :hacks, :pdrive_folders, :dropbox_folders, :published]

  # Validations
  validates :title, :description, :state, presence: true
  validates :url, if: :published, presence: true

  validates :url, format: { with: URI.regexp(%w(http https)) },
    if: Proc.new { |a| a.url.present? }
  validates :github_identifier, format: { with: /\Aunepwcmc\/[-a-zA-Z0-9_.]+\z/i },
    if: Proc.new { |a| a.github_identifier.present? }
  validate :validate_trello_ids
  validate :validate_pivotal_tracker_ids

  validates :state, inclusion: { in: ['Under Development', 'Delivered', 'Project Development', 'Discontinued'] }

  # Mount uploader for carrierwave
  mount_uploader :screenshot, ScreenshotUploader

  before_destroy :has_project_instances

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

  private

  def validate_trello_ids
    if self.trello_ids.detect{ |trello_id| !(/\A([a-z0-9]+\/[-a-z0-9_]+)\z/i.match(trello_id)) }
      errors.add(:trello_ids, :invalid)
    end
  end

  def validate_pivotal_tracker_ids
    if self.pivotal_tracker_ids.detect{ |pt_id| !(/\A\d+(,\d+)*\z/i.match(pt_id)) }
      errors.add(:pivotal_tracker_ids, :invalid)
    end
  end

  def has_project_instances
    unless self.project_instances.empty?
      raise "This project has project instances. Delete its project instances first"
    end
  end
end
