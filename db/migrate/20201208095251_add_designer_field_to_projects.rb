class AddDesignerFieldToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :designers, :string, array: true, default: []
  end
end
