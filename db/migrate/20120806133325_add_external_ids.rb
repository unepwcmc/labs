class AddExternalIds < ActiveRecord::Migration
  def change
    add_column :projects, :github_id, :string
    add_column :projects, :pivotal_tracker_id, :integer
    add_column :projects, :toggl_id, :integer
  end
end
