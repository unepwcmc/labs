class AddDeletedAtToProjectInstancesAndInstallations < ActiveRecord::Migration
  def change
    add_column :project_instances, :deleted_at, :datetime
    add_index :project_instances, :deleted_at

    add_column :installations, :deleted_at, :datetime
    add_index :installations, :deleted_at

    add_column :project_instances, :closing, :boolean, default: false
    add_column :installations, :closing, :boolean, default: false
  end
end
