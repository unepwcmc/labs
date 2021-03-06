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
  serialize :level_of_involvement

  def self.instance
    first || construct_instance
  end

  def self.quick_refresh(project = nil)
    return first.update_attributes(db_statistics) if project.nil?

    first.update_attributes(serializer.quick_refresh(project))
  end

  def self.refresh_values
    obj = first
    unless obj
      construct_instance
      return
    end
    obj.update_attributes(serializer.serialize)
  end

  def self.construct_instance
    create(serializer.serialize)
  end

  def self.db_statistics
    serializer.db_statistics
  end

  def self.api_imports
    serializer.api_imports
  end

  def self.serializer
    @serializer ||= KpiSerializer.new
  end
end
