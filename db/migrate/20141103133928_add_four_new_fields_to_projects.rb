class AddFourNewFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :rails_version, :string
    add_column :projects, :ruby_version, :string
    add_column :projects, :postgresql_version, :string
    add_column :projects, :other_technologies, :text, array: true, default: []
  end
end
