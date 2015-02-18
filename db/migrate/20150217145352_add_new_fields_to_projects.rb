class AddNewFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :background_jobs, :text
    add_column :projects, :cron_jobs, :text
  end
end
