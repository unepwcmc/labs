class AddSeverityHashToKpi < ActiveRecord::Migration[5.0]
  def change
    add_column :kpis, :bugs_severity, :text
  end
end
