class CreateProjectInstances < ActiveRecord::Migration
  def up
    create_table :project_instances do |t|
      t.references :project, index: true, null: false
      t.string :name, null: false
      t.string :url, null: false
      t.text :backup_information
      t.string :stage, null: false
      t.string :branch
      t.text :description
      t.timestamps
    end

    add_reference :installations, :project_instance, index: true

    change_column :installations, :project_instance_id, :integer, null: false

  end

  def down
    # ProjectInstance model has been deleted.

    # ProjectInstance.destroy_all
    drop_table :project_instances

    remove_column :installations, :project_instance_id
  end
end
