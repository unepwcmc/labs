# frozen_string_literal: true

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
#  user_access           :text
#

class Project < ApplicationRecord
  # Add pg_search
  include PgSearch
  include ActiveModel::Dirty

  # Relationships
  has_many :comments, as: :commentable

  has_many :master_sub_relationship, foreign_key: 'sub_project_id',
                                     class_name: 'Dependency', dependent: :destroy
  has_many :master_projects, through: :master_sub_relationship

  has_many :sub_master_relationship, foreign_key: 'master_project_id',
                                     class_name: 'Dependency', dependent: :destroy
  has_many :sub_projects, through: :sub_master_relationship

  has_many :project_instances
  has_many :reviews, dependent: :destroy

  LEADS = ['Informatics', 'Co-design', 'In-house agency'].freeze

  STATES = ['Unknown', 'Not Started', 'In Progress', 'Paused', 'Completed',
    'Launched (No Maintenance)', 'Launched (Support & Maintenance)', 'Orphaned',
    'Offline', 'Abandoned'].freeze

  # Custom search scope for publically viewable projects
  SEARCH_SCOPE = %i[title description github_identifier state internal_clients
    current_lead external_clients project_leads developers designers
    dependencies hacks codebase_url design_link sharepoint_link ga_tracking_code
    expected_release_date rails_version ruby_version postgresql_version other_technologies].freeze

  pg_search_scope :search, using: { tsearch: { prefix: true } }, against: SEARCH_SCOPE

  scope :published, -> { where(published: true) }

  # multisearchable against: [:title, :description, :github_identifier, :state, :internal_clients,
  #           :current_lead, :external_clients, :project_leads, :developers,
  #           :dependencies, :hacks, :pdrive_folders, :dropbox_folders, :published]

  # Validations

  validates :title, :description, :state, presence: true
  validates :url, if: :published, presence: true, format: { with: URI.regexp(%w[http https]) }

  # FIXME: Doesn't seem to work
  # validates :github_identifier, format: { with: /\A[-a-zA-Z0-9_.]+\/[-a-zA-Z0-9_.]+\z/i },
  #   if: Proc.new { |a| a.github_identifier.present? }

  validates :state, inclusion: { in: STATES, message: 'has to be a valid state' }
  validates :project_leading_style, inclusion: { in: LEADS, message: 'has to be a valid option' }
  validates :sharepoint_link, :codebase_url, :design_link,
            format: { with: URI.regexp(%w[http https]), message: 'needs to be a valid URL (add a http:// or https://)' }, allow_blank: true
  validates :ga_tracking_code, absence: true, unless: :url_present?
  validates :ga_tracking_code, format: { with: /\AUA-\d+-\d{1}\z/, message: 'has to be a valid code' }, allow_blank: true

  accepts_nested_attributes_for :master_sub_relationship, allow_destroy: true
  accepts_nested_attributes_for :sub_master_relationship, allow_destroy: true

  after_update :refresh_reviews
  after_update :refresh_kpi_information
  after_touch :refresh_reviews

  # Mount uploader for carrierwave
  mount_uploader :screenshot, ScreenshotUploader

  # Create array getter and setter methods for postgres
  ["developers","designers","internal_clients","external_clients","project_leads","other_technologies"].each do |attribute|
  	define_method("#{attribute}_array") do
  		self.send(attribute).join(',')
  	end

  	define_method("#{attribute}_array=") do |params|
      self.send("#{attribute}=", params.split(','))
      self.send(:save)
  	end
  end

  def url_present?
    !url.blank?
  end

  def last_review
    reviews.last
  end

  def team_members?
    !(developers.empty? || designers.empty? || current_lead.blank?)
  end

  def instances_with_installations
    project_instances.reload.includes(:installations).references(:installations)
                     .where('installations.id IS NOT NULL')
  end

  def production_instance?
    !instances_with_installations.where(stage: 'Production').empty?
  end

  def staging_instance?
    !instances_with_installations.where(stage: 'Staging').empty?
  end

  def production_backups?
    !instances_with_installations.where(stage: 'Production')
                                 .where("backup_information IS NOT NULL AND backup_information != '' ").empty?
  end

  def refresh_reviews
    reviews.each(&:respond_to_project_update)
  end

  def refresh_kpi_information
    return Kpi.instance if Kpi.first.nil?

    # Uses streamlined methods to quickly get new info (mainly to speed up the Snyk importer)
    Kpi.quick_refresh(self)
  end

  def sync_with_github
    github = Github.new
    repo = github_identifier.split('/').last
    project_params = {
      rails_version: github.get_rails_version(repo),
      ruby_version: github.get_ruby_version(repo)
    }
    update_attributes(project_params)
  end
  
  def self.pluck_field(symbol)
    pluck(symbol).compact.uniq.reject(&:empty?).sort
  end
end
