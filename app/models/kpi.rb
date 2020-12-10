# frozen_string_literal: true

class Kpi < ApplicationRecord
  validates_inclusion_of :singleton_guard, in: [0]

  serialize :bugs_severity

  ACTIVE_STATUSES = [
    'Launched (No Maintenance)',
    'Launched (Support & Maintenance)',
    'Completed'
  ].freeze

  def self.instance
    first || construct_instance
  end

  def refresh_values
    obj = first
    unless obj
      construct_instance
      return
    end
    obj.update_attributes(instance_hash)
  end

  def self.construct_instance
    create(instance_hash)
  end

  def instance_hash 
    db_statistics.merge(imported_stats)
  end

  def db_statistics
    {
      percentage_currently_active_products: currently_active_products,
      percentage_projects_with_kpis: projects_with_kpis,
      percentage_projects_documented: projects_with_documentation
    }
  end

  def imported_stats
    # Instantiate new instances of the importers
    {
      bugs_backlog_size: Kpi::CodebaseImporter.bugs_backlog_size[:ticket_count],
      bugs_severity: Kpi::CodebaseImporter.bugs_backlog_size[:severity],
      percentage_secure_projects: Kpi::SnykStatisticsImporter.vulnerabilities_per_project,
      percentage_projects_with_ci: Kpi::CiImporter.find_projects_with_ci
    }
  end

  private

  def currently_active_products
    active_projects = Project.where(state: ACTIVE_STATUSES).where.not(last_commit_date: nil)

    convert_to_percentage(active_projects)
  end

  def projects_with_kpis
    convert_to_percentage(Project.where.not(key_performance_indicator: nil))
  end

  def projects_with_documentation
    convert_to_percentage(Project.where.not(documentation_link: nil))
  end

  def convert_to_percentage(count)
    ((count.to_f / Project.count) * 100).round(2)
  end
end
