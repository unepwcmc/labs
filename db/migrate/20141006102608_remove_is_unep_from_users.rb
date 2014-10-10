class RemoveIsUnepFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :is_unep
  end
end
