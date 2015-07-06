class CreateExportViews < ActiveRecord::Migration
  def change
    execute "DROP VIEW IF EXISTS projects_export"
    execute "CREATE VIEW projects_export AS #{view_sql('20150706110532', 'projects_export')}"
    execute "DROP VIEW IF EXISTS species_projects_export"
    execute "CREATE VIEW species_projects_export AS #{view_sql('20150706110532', 'species_projects_export')}"
  end
end
