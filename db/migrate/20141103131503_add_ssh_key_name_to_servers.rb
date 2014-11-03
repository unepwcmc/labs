class AddSshKeyNameToServers < ActiveRecord::Migration
  def change
    add_column :servers, :ssh_key_name, :text
  end
end
