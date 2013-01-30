class AddDashboardFlagToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_dashboard_only, :boolean, :default => true
  end
end
