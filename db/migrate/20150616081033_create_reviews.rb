class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :project_id, null: false
      t.integer :reviewer_id, null: false
      t.decimal :result, null: false

      t.timestamps
    end
    add_foreign_key :reviews, :projects, column: :project_id, dependent: :delete
    add_foreign_key :reviews, :users, column: :reviewer_id, dependent: :nullify
  end
end
