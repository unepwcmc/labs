class RecreateColumnsForArraysonProjects < ActiveRecord::Migration
  def change
  	remove_column :projects, :external_clients
	remove_column :projects, :project_leads
	remove_column :projects, :developers
	remove_column :projects, :pdrive_folders
	remove_column :projects, :dropbox_folders

  	add_column :projects, :external_clients, :text, array: true, default: []
	add_column :projects, :project_leads, :text, array: true, default: []
	add_column :projects, :developers, :text, array: true, default: []
	add_column :projects, :pdrive_folders, :text, array: true, default: []
	add_column :projects, :dropbox_folders, :text, array: true, default: []
  end
end
