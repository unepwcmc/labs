# frozen_string_literal: true

class Kpi < ApplicationRecord
  validates_inclusion_of :singleton_guard, in: [0]

  serialize :bugs_severity
  serialize :project_vulnerability_counts
  serialize :percentage_currently_active_products
  serialize :percentage_projects_with_kpis
  serialize :percentage_projects_documented
  serialize :percentage_projects_with_ci

  ACTIVE_STATUSES = [
    'Launched (No Maintenance)',
    'Launched (Support & Maintenance)',
    'Completed'
  ].freeze

  def self.instance
    first || construct_instance
  end

  def self.refresh_values
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

  def self.instance_hash 
    db_statistics.merge(imported_stats)
  end

  def self.db_statistics
    {
      percentage_currently_active_products: currently_active_products,
      percentage_projects_with_kpis: projects_with_kpis,
      percentage_projects_documented: projects_with_documentation
    }
  end

  def self.imported_stats
    # API imports
    {
      bugs_backlog_size: Kpi::CodebaseImporter.bugs_backlog_size[:ticket_count],
      bugs_severity: Kpi::CodebaseImporter.bugs_backlog_size[:severity],
      percentage_projects_with_ci: projects_with_ci,
      project_vulnerability_counts: Kpi::SnykStatisticsImporter.vulnerabilities_per_project
    }
  end

  def self.projects_with_ci
    projects_with_ci = Kpi::CiImporter.find_projects_with_ci

    {
      ci_present: convert_to_percentage(projects_with_ci),
      ci_absent: convert_to_percentage(Project.count - projects_with_ci)
    }
  end

  def self.currently_active_products
    active_projects = Project.where(state: ACTIVE_STATUSES).where.not(last_commit_date: nil).count

    {
      active_products: convert_to_percentage(active_projects),
      inactive_products: convert_to_percentage(Project.count - active_projects)
    }
  end

  def self.projects_with_kpis
    projects_with_kpis = Project.where.not(key_performance_indicator: nil).count

    {
      kpis_present: convert_to_percentage(projects_with_kpis),
      no_kpis_present: convert_to_percentage(Project.count - projects_with_kpis)
    }
  end

  def self.projects_with_documentation
    with_documentation = Project.where.not(documentation_link: nil).count

    {
      with_documentation: convert_to_percentage(with_documentation),
      without_documentation: convert_to_percentage(Project.count - with_documentation)
    }
  end

  def self.convert_to_percentage(count)
    ((count.to_f / Project.count) * 100).round(2)
  end

  private_class_method :currently_active_products, :projects_with_kpis, :projects_with_ci,
                       :projects_with_documentation, :convert_to_percentage
end
