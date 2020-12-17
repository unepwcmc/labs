class ChangeKpiFieldsToSerializables < ActiveRecord::Migration[5.0]
  def change
    change_column :kpis, :percentage_currently_active_products, :text
    change_column :kpis, :percentage_projects_with_kpis, :text
    change_column :kpis, :percentage_projects_documented, :text
    change_column :kpis, :percentage_projects_with_ci, :text
  end
end
