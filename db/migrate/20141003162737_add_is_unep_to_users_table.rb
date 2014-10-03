class AddIsUnepToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :is_unep, :boolean, default: false
  end
end
