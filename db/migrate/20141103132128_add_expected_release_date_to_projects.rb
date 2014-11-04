class AddExpectedReleaseDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :expected_release_date, :date
  end
end
