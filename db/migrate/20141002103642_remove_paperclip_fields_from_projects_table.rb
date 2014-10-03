class RemovePaperclipFieldsFromProjectsTable < ActiveRecord::Migration
  def change
	remove_column :projects, :screenshot_file_name
	remove_column :projects, :screenshot_content_type
	remove_column :projects, :screenshot_file_size
	remove_column :projects, :screenshot_updated_at
  end
end
