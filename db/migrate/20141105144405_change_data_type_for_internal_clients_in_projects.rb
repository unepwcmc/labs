class ChangeDataTypeForInternalClientsInProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :internal_client

    add_column :projects, :internal_clients, :text, array: true, default: []
  end
end
