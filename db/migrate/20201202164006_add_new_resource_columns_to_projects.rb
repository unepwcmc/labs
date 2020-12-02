class AddNewResourceColumnsToProjects < ActiveRecord::Migration[5.0]
  def change
    # Left over resource columns kept for reference
    add_column :projects, :codebase_url, :text
    add_column :projects, :design_link, :text
    add_column :projects, :sharepoint_link, :text
    add_column :projects, :ga_tracking_code, :text
  end
end
