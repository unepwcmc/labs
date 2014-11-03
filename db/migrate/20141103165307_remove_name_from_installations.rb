class RemoveNameFromInstallations < ActiveRecord::Migration
  def change
    remove_column :installations, :name, :string
  end
end
