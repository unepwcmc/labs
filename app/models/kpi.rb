# frozen_string_literal: true

class Kpi < ApplicationRecord
  validates_inclusion_of :singleton_guard, in: [0]

  serialize :bugs_severity
  serialize :project_vulnerability_counts
  serialize :percentage_currently_active_products
  serialize :percentage_projects_with_kpis
  serialize :percentage_projects_documented
  serialize :percentage_projects_with_ci
  serialize :manual_yearly_updates_overview
  serialize :project_breakdown

  ACTIVE_STATUSES = [
    'Launched (No Maintenance)',
    'Launched (Support & Maintenance)',
    'Completed'
  ].freeze

  def self.instance
    first || construct_instance
  end

  def self.quick_refresh(project = nil)
    first.update_attributes(db_statistics) if project.nil?

    snyk_stats = Kpi::SnykStatisticsImporter.update_single_project(project)
   
    first.update_attributes(db_statistics.merge(
      api_imports.merge(
        project_vulnerability_counts: snyk_stats[:vulnerability_hash],
        project_breakdown: snyk_stats[:projects]
      )
    ))
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
      percentage_projects_documented: projects_with_documentation,
      manual_yearly_updates_overview: manual_yearly_updates_overview
    }
  end

  def self.imported_stats
    snyk_stats = Kpi::SnykStatisticsImporter.vulnerabilities_per_project

    # API imports
    api_imports.merge({
      project_vulnerability_counts: snyk_stats[:vulnerability_hash],
      project_breakdown: snyk_stats[:projects]
    })
  end

  def self.api_imports 
    {
      bugs_backlog_size: Kpi::CodebaseImporter.bugs_backlog_size[:ticket_count],
      bugs_severity: Kpi::CodebaseImporter.bugs_backlog_size[:severity],
      percentage_projects_with_ci: projects_with_ci
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
    feasible_kpis = Project.where.not(is_feasible: false, key_performance_indicator: nil).count
    unfeasible_kpis = Project.where.not(is_feasible: true, key_performance_indicator: nil).count

    {
      feasible_kpis: convert_to_percentage(feasible_kpis),
      unfeasible_kpis: convert_to_percentage(unfeasible_kpis),
      no_kpis_present: convert_to_percentage(Project.count - (feasible_kpis + unfeasible_kpis))
    }
  end

  def self.projects_with_documentation
    adequate_documentation = Project.where.not(is_documentation_adequate: false, documentation_link: nil).count
    inadequate_documentation = Project.where.not(is_documentation_adequate: true, documentation_link: nil).count

    {
      adequate_documentation: convert_to_percentage(adequate_documentation),
      inadequate_documentation: convert_to_percentage(inadequate_documentation),
      without_documentation: convert_to_percentage(Project.count - (adequate_documentation + inadequate_documentation))
    }
  end

  def self.manual_yearly_updates_overview
    none = 0
    zero_to_ten = 0
    more_than_ten = 0

    Project.find_each do |project|
      if project.manual_yearly_updates.zero?
        none += 1 
      elsif project.manual_yearly_updates.positive? && project.manual_yearly_updates < 10
        zero_to_ten += 1
      else
        more_than_ten += 1
      end
    end

    {
      none: none,
      "0 to 10": zero_to_ten,
      "10 to 20": more_than_ten
    }
  end

  def self.convert_to_percentage(count)
    ((count.to_f / Project.count) * 100).round(2)
  end

  private_class_method :currently_active_products, :projects_with_kpis, :projects_with_ci,
                       :projects_with_documentation, :manual_yearly_updates_overview, :convert_to_percentage
end
