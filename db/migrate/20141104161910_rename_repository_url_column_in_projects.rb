class RenameRepositoryUrlColumnInProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :repository_url, :github_identifier
  end
end
