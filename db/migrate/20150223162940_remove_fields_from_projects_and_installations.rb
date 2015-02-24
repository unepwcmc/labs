class RemoveFieldsFromProjectsAndInstallations < ActiveRecord::Migration
  def change
    remove_column :projects, :backup_information
    remove_column :installations, :stage
    remove_column :installations, :branch
    remove_column :installations, :url
    remove_column :installations, :project_id
  end
end
