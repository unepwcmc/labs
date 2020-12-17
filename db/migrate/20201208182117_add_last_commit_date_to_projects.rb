class AddLastCommitDateToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :last_commit_date, :date
  end
end
