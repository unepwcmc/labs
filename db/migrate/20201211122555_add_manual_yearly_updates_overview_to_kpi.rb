class AddManualYearlyUpdatesOverviewToKpi < ActiveRecord::Migration[5.0]
  def change
    add_column :kpis, :manual_year_updates_overview, :text
  end
end
