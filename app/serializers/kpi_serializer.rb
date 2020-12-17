# frozen_string_literal: true

class KpiSerializer
  ACTIVE_STATUSES = [
    'Launched (No Maintenance)',
    'Launched (Support & Maintenance)',
    'Completed'
  ].freeze

  def initialize
    @_model = Kpi
  end

  def serialize
    db_statistics.merge(imported_stats)
  end

  def db_statistics
    {
      percentage_currently_active_products: currently_active_products,
      percentage_projects_with_kpis: projects_with_kpis,
      percentage_projects_documented: projects_with_documentation,
      manual_yearly_updates_overview: manual_yearly_updates_overview,
      total_income: project_income_sum,
      level_of_involvement: projects_led
    }
  end

  def api_imports
    bugs_backlog = Kpi::CodebaseImporter.bugs_backlog_size

    {
      bugs_backlog_size: bugs_backlog[:ticket_count],
      bugs_severity: bugs_backlog[:severity],
      percentage_projects_with_ci: projects_with_ci
    }
  end

  def imported_stats
    snyk_stats = Kpi::SnykStatisticsImporter.vulnerabilities_per_project

    # API imports
    api_imports.merge({
                        project_vulnerability_counts: snyk_stats[:vulnerability_hash],
                        project_breakdown: snyk_stats[:projects]
                      })
  end

  def project_income_sum
    Project.pluck(:income_earned).compact.inject(&:x)
  end

  def projects_led
    hash = Hash.new(0)

    Project.pluck(:project_leading_style).each do |style|
      style.nil? ? hash['Unknown'] += 1 : hash[style] += 1
    end

    hash
  end

  def projects_with_ci
    projects_with_ci = Kpi::CiImporter.find_projects_with_ci

    convert_to_percentage({
                            ci_present: projects_with_ci,
                            ci_absent: Project.count - projects_with_ci
                          })
  end

  def currently_active_products
    active_projects = Project.where(state: ACTIVE_STATUSES).or(Project.where.not(last_commit_date: nil)).count

    convert_to_percentage({
                            active_products: active_projects,
                            inactive_products: Project.count - active_projects
                          })
  end

  def projects_with_kpis
    feasible_kpis = Project.where.not(is_feasible: false, key_performance_indicator: nil).count
    unfeasible_kpis = Project.where.not(is_feasible: true, key_performance_indicator: nil).count

    convert_to_percentage({
                            feasible_kpis: feasible_kpis,
                            unfeasible_kpis: unfeasible_kpis,
                            no_kpis_present: Project.count - (feasible_kpis + unfeasible_kpis)
                          })
  end

  def projects_with_documentation
    adequate_documentation = Project.where.not(is_documentation_adequate: false, documentation_link: nil).count
    inadequate_documentation = Project.where.not(is_documentation_adequate: true, documentation_link: nil).count

    convert_to_percentage({
                            adequate_documentation: adequate_documentation,
                            inadequate_documentation: inadequate_documentation,
                            without_documentation: Project.count - (adequate_documentation + inadequate_documentation)
                          })
  end

  def manual_yearly_updates_overview
    hash = Hash.new(0)

    Project.find_each do |project|
      if project.manual_yearly_updates.zero?
        hash[:none] += 1
      elsif project.manual_yearly_updates.positive? && project.manual_yearly_updates < 10
        hash['0 to 10'] += 1
      else
        hash['10 to 20'] += 1
      end
    end

    hash
  end

  def convert_to_percentage(hash)
    hash.each { |_key, value| ((value.to_f / Project.count) * 100).round(2) }
  end
end
