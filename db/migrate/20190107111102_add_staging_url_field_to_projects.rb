class AddStagingUrlFieldToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :url_staging, :string
  end
end