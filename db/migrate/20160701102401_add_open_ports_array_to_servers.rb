class AddOpenPortsArrayToServers < ActiveRecord::Migration
  def up
    add_column :servers, :open_ports, :text, array: true, default: []
  end

  def down
    remove_column :servers, :open_ports
  end
end
