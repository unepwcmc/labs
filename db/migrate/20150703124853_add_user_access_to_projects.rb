class AddUserAccessToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :user_access, :text
  end
end
