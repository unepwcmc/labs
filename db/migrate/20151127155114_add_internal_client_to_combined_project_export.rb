class AddInternalClientToCombinedProjectExport < ActiveRecord::Migration
  def up
    execute "DROP VIEW IF EXISTS combined_projects_export"
    execute "CREATE VIEW combined_projects_export AS #{view_sql('20151127155114', 'combined_projects_export')}"
  end

  def down
    execute "DROP VIEW IF EXISTS combined_projects_export"
    execute "CREATE VIEW combined_projects_export AS #{view_sql('20150706110532', 'combined_projects_export')}"
  end
end
