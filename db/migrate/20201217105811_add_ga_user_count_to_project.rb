class AddGaUserCountToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :google_analytics_user_count, :integer
    add_column :projects, :ga_view_id, :string
  end
end
