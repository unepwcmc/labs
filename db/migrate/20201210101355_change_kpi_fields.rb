class ChangeKpiFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :kpis, :percentage_secure_projects, :project_vulnerability_counts
    change_column :kpis, :project_vulnerability_counts, :text
  end
end
