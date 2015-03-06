class AddDefaultToStageOnProjectInstances < ActiveRecord::Migration
  def up
    change_column :project_instances, :stage, :string, default: "Production"
  end

  def down
    change_column :project_instances, :stage, :string, default: nil
  end
end

