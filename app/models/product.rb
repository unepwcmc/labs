# frozen_string_literal: true

# == Schema Information
#
# Table name: products
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
#  product_leads         :text             default([]), is an Array
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

class Product < ApplicationRecord
  # Add pg_search
  include PgSearch
  include ActiveModel::Dirty
  include GoogleAnalytics

  # Relationships
  has_many :comments, as: :commentable

  has_many :master_sub_relationship, foreign_key: 'sub_product_id',
                                     class_name: 'Dependency', dependent: :destroy
  has_many :master_products, through: :master_sub_relationship

  has_many :sub_master_relationship, foreign_key: 'master_product_id',
                                     class_name: 'Dependency', dependent: :destroy
  has_many :sub_products, through: :sub_master_relationship

  has_many :product_instances
  has_many :reviews, dependent: :destroy

  LEADS = ['Informatics', 'Co-design', 'In-house agency'].freeze

  STATES = ['Unknown', 'Not Started', 'In Progress', 'Paused', 'Completed',
    'Launched (No Maintenance)', 'Launched (Support & Maintenance)', 'Orphaned',
    'Offline', 'Abandoned'].freeze

  # Custom search scope for publically viewable products
  SEARCH_SCOPE = %i[title description github_identifier state internal_clients
    current_lead external_clients product_leads developers designers
    dependencies hacks codebase_url design_link sharepoint_link ga_tracking_code
    expected_release_date rails_version ruby_version postgresql_version other_technologies].freeze

  pg_search_scope :search, using: { tsearch: { prefix: true } }, against: SEARCH_SCOPE

  scope :published, -> { where(published: true) }
  scope :tracked_products, -> { where.not(ga_tracking_code: [nil, ""]) }
  # multisearchable against: [:title, :description, :github_identifier, :state, :internal_clients,
  #           :current_lead, :external_clients, :product_leads, :developers,
  #           :dependencies, :hacks, :pdrive_folders, :dropbox_folders, :published]

  # Validations

  validates :title, :description, :state, presence: true
  validates :url, if: :published, presence: true, format: { with: URI.regexp(%w[http https]) }

  # FIXME: Doesn't seem to work
  # validates :github_identifier, format: { with: /\A[-a-zA-Z0-9_.]+\/[-a-zA-Z0-9_.]+\z/i },
  #   if: Proc.new { |a| a.github_identifier.present? }

  validates :state, inclusion: { in: STATES, message: 'has to be a valid state' }
  validates :product_leading_style, inclusion: { in: LEADS, message: 'has to be a valid option' }
  validates :sharepoint_link, :codebase_url, :design_link,
            format: { with: URI.regexp(%w[http https]), message: 'needs to be a valid URL (add a http:// or https://)' }, allow_blank: true
  validates :ga_tracking_code, absence: true, unless: :url_present?
  validates :ga_tracking_code, format: { with: /\d+/, message: 'has to be a valid code' }, length: { in: 8..9 }, allow_blank: true

  accepts_nested_attributes_for :master_sub_relationship, allow_destroy: true
  accepts_nested_attributes_for :sub_master_relationship, allow_destroy: true

  after_update :refresh_reviews
  after_update :refresh_kpi_information
  after_touch :refresh_reviews

  # Mount uploader for carrierwave
  mount_uploader :screenshot, ScreenshotUploader

  # Create array getter and setter methods for postgres
  ["developers","designers","internal_clients","external_clients","product_leads","other_technologies"].each do |attribute|
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
    product_instances.reload.includes(:installations).references(:installations)
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
    reviews.each(&:respond_to_product_update)
  end

  def refresh_kpi_information
    return Kpi.instance if Kpi.first.nil?

    # Uses streamlined methods to quickly get new info (mainly to speed up the Snyk importer)
    Kpi.quick_refresh(self)
  end

  def sync_with_github
    github = Github.new
    repo = github_identifier.split('/').last
    product_params = {
      rails_version: github.get_rails_version(repo),
      ruby_version: github.get_ruby_version(repo)
    }
    update_attributes(product_params)
  end

  # Logic below should be abstracted out into a background job
  def user_count_in_last_90_days
    return if ga_tracking_code.blank?

    ga_reporting_api = GoogleAnalytics::Reporting.new(ga_tracking_code)

    updated_user_count = ga_reporting_api.send_request

    update(google_analytics_user_count: updated_user_count)
  rescue GoogleAnalytics::BadResponseError => e
    errors.add(:base, e.message)
    false
  rescue Google::Apis::ClientError => e
    errors.add(:base, 'Check your product tracking code - is it correct?')
    false
  end
  
  def self.pluck_field(symbol)
    pluck(symbol).compact.uniq.reject(&:empty?).sort
  end
end
