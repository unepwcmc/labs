class AddDeletedAtToServers < ActiveRecord::Migration
  def change
    add_column :servers, :deleted_at, :datetime
    add_index :servers, :deleted_at
  end
end
