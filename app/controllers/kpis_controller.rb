class KpisController < ApplicationController
  ACTIVE_STATUSES = [
    'Launched (No Maintenance)',
    'Launched (Support & Maintenance)',
    'Completed'
  ].freeze

  def index
  end

  def kpi_endpoint
    render json: Kpi.instance.attributes.merge(
      {
        active_products: currently_active_products,
        feasibility: projects_with_kpis,
        documentation: projects_with_documentation,
        manual_updates: manual_yearly_updates_overview
      }
    )
  end

  private

  def currently_active_products
    active_projects = Project.where(state: ACTIVE_STATUSES).where.not(last_commit_date: nil).count

    {
      active_products: convert_to_percentage(active_projects),
      inactive_products: convert_to_percentage(Project.count - active_projects)
    }
  end

  def projects_with_kpis
    feasible_kpis = Project.where.not(is_feasible: false, key_performance_indicator: nil).count
    unfeasible_kpis = Project.where.not(is_feasible: true, key_performance_indicator: nil).count

    {
      kpis_present: convert_to_percentage(feasible_kpis),
      unfeasible_kpis: convert_to_percentage(unfeasible_kpis),
      no_kpis_present: convert_to_percentage(Project.count - (feasible_kpis + unfeasible_kpis))
    }
  end

  def projects_with_documentation
    adequate_documentation = Project.where.not(is_documentation_adequate: false, documentation_link: nil).count
    inadequate_documentation = Project.where.not(is_documentation_adequate: true, documentation_link: nil).count

    {
      adequate_documentation: convert_to_percentage(adequate_documentation),
      inadequate_documentation: convert_to_percentage(inadequate_documentation),
      without_documentation: convert_to_percentage(Project.count - (adequate_documentation + inadequate_documentation))
    }
  end

  def manual_yearly_updates_overview
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

  def convert_to_percentage(count)
    ((count.to_f / Project.count) * 100).round(2)
  end
end