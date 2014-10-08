class AddFieldsToProjects < ActiveRecord::Migration
  def change
	add_column :projects, :repository_url, :string
	add_column :projects, :dependencies, :text
	add_column :projects, :state, :string
	add_column :projects, :internal_client, :string
	add_column :projects, :current_lead, :string
	add_column :projects, :hacks, :text
	add_column :projects, :external_clients, :string, array: true
	add_column :projects, :project_leads, :string, array: true
	add_column :projects, :developers, :string, array: true
	add_column :projects, :pdrive_folders, :string, array: true
	add_column :projects, :dropbox_folders, :string, array: true
	rename_column :projects, :is_dashboard_only, :published
	change_column_default :projects, :published, false
  end
end
