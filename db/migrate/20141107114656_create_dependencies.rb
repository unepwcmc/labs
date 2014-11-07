class CreateDependencies < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
      t.column :master_project_id, :integer, :null => false
      t.column :sub_project_id, :integer, :null => false
      t.column :description, :text
      
      t.timestamps
    end
  end
end
