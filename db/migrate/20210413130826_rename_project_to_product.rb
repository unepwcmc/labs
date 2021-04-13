class RenameProjectToProduct < ActiveRecord::Migration[5.0]
  def change
    rename_table :projects, :products
    rename_table :project_instances, :product_instances
    rename_table :project_instances_import, :product_instances_import
    rename_table :projects_export, :products_export
  end
end
