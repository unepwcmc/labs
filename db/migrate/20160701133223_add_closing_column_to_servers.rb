class AddClosingColumnToServers < ActiveRecord::Migration
  def change
    add_column :servers, :closing, :boolean, default: false
  end
end
