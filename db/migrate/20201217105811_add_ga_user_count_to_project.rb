class AddGaUserCountToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :google_analytics_user_count, :integer
  end
end
