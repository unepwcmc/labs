# frozen_string_literal: true

class Kpi < ApplicationRecord
  validates_inclusion_of :singleton_guard, in: [0]

  serialize :bugs_severity
  serialize :product_vulnerability_counts
  serialize :percentage_currently_active_products
  serialize :percentage_products_with_kpis
  serialize :percentage_products_documented
  serialize :percentage_products_with_ci
  serialize :manual_yearly_updates_overview
  serialize :google_analytics_overview
  serialize :product_breakdown
  serialize :level_of_involvement

  def self.instance
    first || construct_instance
  end

  def self.quick_refresh(product = nil)
    return first.update_attributes(db_statistics) if product.nil?

    first.update_attributes(serializer.quick_refresh(product))
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
