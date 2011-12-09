class AddScreenshotToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :screenshot_file_name, :string
    add_column :projects, :screenshot_content_type, :string
    add_column :projects, :screenshot_file_size, :integer
    add_column :projects, :screenshot_updated_at, :datetime
  end
end
