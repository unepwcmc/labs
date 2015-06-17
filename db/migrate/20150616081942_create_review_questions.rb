class CreateReviewQuestions < ActiveRecord::Migration
  def change
    create_table :review_questions do |t|
      t.integer :review_section_id, null: false
      t.text :code, null: false, unique: true
      t.text :title, null: false
      t.text :description
      t.integer :sort_order, null: false, default: 0
      t.boolean :skippable, default: false
      t.text :auto_check

      t.timestamps
    end
    add_foreign_key :review_questions, :review_sections, column: :review_section_id, dependent: :delete
  end
end
