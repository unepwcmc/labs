class AddProjectBreakdownToKpi < ActiveRecord::Migration[5.0]
  def change
    add_column :kpis, :project_breakdown, :text
  end
end
