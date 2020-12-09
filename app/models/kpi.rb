# frozen_string_literal: true

class Kpi < ApplicationRecord
  validates_inclusion_of :singleton_guard, in: [0]

  ACTIVE_STATUSES = [
    'Launched (No Maintenance)',
    'Launched (Support & Maintenance)',
    'Completed'
  ].freeze

  def self.instance
    first || construct_instance
  end

  def self.construct_instance
    db_statistics = {
      percentage_currently_active_products: currently_active_products,
      percentage_projects_with_kpis: projects_with_kpis,
      percentage_projects_documented: projects_with_documentation
    }

    # Instantiate new instances of the importers

  end

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
    (count.to_f / Project.count) * 100
  end
end
