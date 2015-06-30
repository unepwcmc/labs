class CreateReviewSections < ActiveRecord::Migration
  def change
    create_table :review_sections do |t|
      t.text :code, null: false, unique: true
      t.text :title, null: false
      t.integer :sort_order, null: false, default: 0

      t.timestamps
    end
  end
end
