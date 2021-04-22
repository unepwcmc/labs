class ChangeDataTypeForInternalClientsInProjects < ActiveRecord::Migration
  def change
    add_column :projects, :internal_clients, :text, array: true, default: []

    # The Project model has now been renamed and therefore this
    # code is invalid. For development purposes, you can import
    # a database dump from either production or staging.

    # The mapping of internal_client to internal_clients has
    # already taken place on the staging and production databases. 

    # Project.reset_column_information

    # Project.all.each do |p|
    #   p.internal_clients << p.try(:internal_client)
    #   p.save
    # end

    remove_column :projects, :internal_client, :string
  end
end
