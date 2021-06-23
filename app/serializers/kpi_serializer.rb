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

  def quick_refresh(product)
    snyk_stats = Kpis::SnykStatisticsImporter.update_single_product(product)

    db_statistics.merge(
      api_imports.merge(
        product_vulnerability_counts: snyk_stats[:vulnerability_hash],
        product_breakdown: snyk_stats[:products]
      )
    )
  end

  def db_statistics
    {
      percentage_currently_active_products: currently_active_products,
      percentage_products_with_kpis: products_with_kpis,
      percentage_products_documented: products_with_documentation,
      manual_yearly_updates_overview: manual_yearly_updates_overview,
      total_income: product_income_sum,
      level_of_involvement: products_led,
      google_analytics_overview: product_user_count
    }
  end

  def api_imports
    bugs_backlog = Kpis::CodebaseImporter.bugs_backlog_size

    {
      bugs_backlog_size: bugs_backlog[:ticket_count],
      bugs_severity: bugs_backlog[:severity],
      percentage_products_with_ci: products_with_ci
    }
  end

  def imported_stats
    snyk_stats = Kpis::SnykStatisticsImporter.vulnerabilities_per_product

    # API imports
    api_imports.merge({
                        product_vulnerability_counts: snyk_stats[:vulnerability_hash],
                        product_breakdown: snyk_stats[:products]
                      })
  end

  def product_income_sum
    Product.pluck(:income_earned).compact.inject(:+)
  end

  def products_led
    hash = Hash.new(0)

    Product.pluck(:product_leading_style).each do |style|
      style.nil? ? hash['Unknown'] += 1 : hash[style] += 1
    end

    hash
  end

  def products_with_ci
    products_with_ci = Kpis::CiImporter.find_products_with_ci

    convert_to_percentage({
                            ci_present: products_with_ci,
                            ci_absent: Product.count - products_with_ci
                          })
  end

  def currently_active_products
    active_products = Product.where(state: ACTIVE_STATUSES).or(Product.where.not(last_commit_date: nil)).count

    convert_to_percentage({
                            active_products: active_products,
                            inactive_products: Product.count - active_products
                          })
  end

  def products_with_kpis
    feasible_kpis = Product.where.not(is_feasible: false, key_performance_indicator: nil).count
    unfeasible_kpis = Product.where.not(is_feasible: true, key_performance_indicator: nil).count

    convert_to_percentage({
                            feasible_kpis: feasible_kpis,
                            unfeasible_kpis: unfeasible_kpis,
                            no_kpis_present: Product.count - (feasible_kpis + unfeasible_kpis)
                          })
  end

  def products_with_documentation
    adequate_documentation = Product.where.not(is_documentation_adequate: false, documentation_link: nil).count
    inadequate_documentation = Product.where.not(is_documentation_adequate: true, documentation_link: nil).count

    convert_to_percentage({
                            adequate_documentation: adequate_documentation,
                            inadequate_documentation: inadequate_documentation,
                            without_documentation: Product.count - (adequate_documentation + inadequate_documentation)
                          })
  end

  def manual_yearly_updates_overview
    hash = Hash.new(0)

    Product.find_each do |product|
      if product.manual_yearly_updates.zero? || product.manual_yearly_updates.negative? 
        hash[:none] += 1
      elsif product.manual_yearly_updates >= 12
        hash['Monthly or more often'] += 1
      elsif product.manual_yearly_updates >= 2
        hash['Every 1 to 6 Months'] += 1
      else
        hash['Every 6 months or less'] += 1
      end
    end

    hash
  end

  def convert_to_percentage(hash)
    hash.each { |_key, value| ((value.to_f / Product.count) * 100).round(2) }
  end

  def product_user_count
    hash = Hash.new(0)
    
    valid_products = Product.tracked_products.where.not(state: 'Offline')

    top_10_products = valid_products.order('google_analytics_user_count DESC').limit(10)
    bottom_10_products = valid_products.order('google_analytics_user_count ASC').limit(10)
    
    hash[:top_10_products] = sort_into_google_analytics_chart_hash(top_10_products)
    hash[:bottom_10_products] = sort_into_google_analytics_chart_hash(bottom_10_products)

    hash
  end

  private

  def sort_into_google_analytics_chart_hash(records)
    hash = Hash.new(0)

    records.each do |record|
      user_count = record.google_analytics_user_count

      unless user_count.nil?
        # Categories may need to be reworked based on the full spectrum of user 
        # counts across all of our products
        if user_count > 1000
          hash[:more_than_1000] += 1
        elsif 750 < user_count && user_count <= 1000
          hash[:"750_to_1000"] += 1
        elsif 500 < user_count && user_count <= 750
          hash[:"500_to_750"] += 1
        else
          add_finer_categories_to(hash, user_count)
        end
      end
    end

    hash
  end

  # Covers 0 to 500
  def add_finer_categories_to(hash, user_count)
    if user_count > 100 && user_count <= 500
      hash[:over_100] += 1
    elsif 75 < user_count && user_count <= 100
      hash[:"75 to 100"] += 1
    elsif 50 < user_count && user_count <= 75
      hash[:"50 to 75"] += 1
    elsif 25 < user_count && user_count <= 50
      hash[:"25 to 50"] += 1
    else
      hash[:"Almost no views (0 to 25)"] += 1
    end
  end
end
