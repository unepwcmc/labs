class AddGoogleAnalyticsOverviewToKpi < ActiveRecord::Migration[5.0]
  def change
    add_column :kpis, :google_analytics_overview, :text
  end
end
