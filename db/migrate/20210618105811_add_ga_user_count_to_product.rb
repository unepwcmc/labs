class AddGaUserCountToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :google_analytics_user_count, :integer
    add_column :products, :ga_view_id, :string
  end
end
