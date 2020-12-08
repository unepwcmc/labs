class AddKpiFieldsToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :income_earned, :float
    add_column :projects, :percentage_live_time_informatics, :float
    add_column :projects, :percentage_live_time_codesign, :float
    add_column :projects, :percentage_live_time_agency, :float
    add_column :projects, :key_performance_indicator, :string
    add_column :projects, :kpi_measurement, :string
    add_column :projects, :is_feasible, :boolean
    add_column :projects, :documentation_link, :string
    add_column :projects, :is_documentation_adequate, :boolean
    add_column :projects, :manual_yearly_updates, :integer, default: 0
  end
end
