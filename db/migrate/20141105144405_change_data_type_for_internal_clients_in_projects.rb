class ChangeDataTypeForInternalClientsInProjects < ActiveRecord::Migration
  def change
    add_column :projects, :internal_clients, :text, array: true, default: []

    Project.reset_column_information

    Project.all.each do |p|
      p.internal_clients << p.try(:internal_client)
      p.save
    end

    remove_column :projects, :internal_client, :string
  end
end
