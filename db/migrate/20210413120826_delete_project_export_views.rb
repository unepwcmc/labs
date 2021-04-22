class DeleteProjectExportViews < ActiveRecord::Migration[5.0]
  def up
    execute "DROP VIEW IF EXISTS combined_projects_export"
    execute "DROP VIEW IF EXISTS projects_export"
  end

  def down
    execute "CREATE VIEW projects_export AS #{view_sql('20150706110532', 'projects_export')}"
    execute "CREATE VIEW combined_projects_export AS #{view_sql('20151127155114', 'combined_projects_export')}"
  end
end
