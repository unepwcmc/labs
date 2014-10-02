class RemoveVariousFieldsFromProjectsTable < ActiveRecord::Migration
  def change
	remove_column :projects, :github_id
	remove_column :projects, :pivotal_tracker_id
	remove_column :projects, :toggl_id
	remove_column :projects, :deadline
  end
end
