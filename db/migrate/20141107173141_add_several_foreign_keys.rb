class AddSeveralForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :dependencies, :projects, column: 'master_project_id'
    add_foreign_key :dependencies, :projects, column: 'sub_project_id'

    add_foreign_key :installations, :projects, dependent: :delete
    add_foreign_key :comments, :users, column: 'user_id'
  end
end
