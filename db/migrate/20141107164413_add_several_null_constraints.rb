class AddSeveralNullConstraints < ActiveRecord::Migration
  def change
    change_column :installations, :project_id, :integer, null: false
    change_column :installations, :server_id, :integer, null: false
    change_column :installations, :role, :string, null: false
    change_column :installations, :stage, :string, null: false
    change_column :installations, :branch, :string, null: false
    change_column :projects, :title, :string, null: false
    change_column :projects, :description, :text, null: false
    change_column :projects, :state, :string, null: false
    change_column :servers, :name, :string, null: false
    change_column :servers, :domain, :string, null: false
    change_column :servers, :os, :string, null: false
    change_column :comments, :content, :text, null: false
    change_column :comments, :commentable_id, :integer, null: false
    change_column :comments, :commentable_type, :string, null: false
    change_column :comments, :user_id, :integer, null: false
  end
end
