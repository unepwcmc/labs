class AddInternalDescriptionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :internal_description, :text
  end
end
