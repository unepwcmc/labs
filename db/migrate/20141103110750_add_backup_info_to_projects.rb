class AddBackupInfoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :backup_information, :text
  end
end
