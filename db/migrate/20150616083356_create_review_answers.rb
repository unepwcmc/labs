class CreateReviewAnswers < ActiveRecord::Migration
  def change
    create_table :review_answers do |t|
      t.integer :review_id, null: false
      t.integer :review_question_id, null: false
      t.boolean :selected_option, null: false, default: false
      t.boolean :skipped, null: false, default: false

      t.timestamps
    end
    add_foreign_key :review_answers, :reviews, column: :review_id, dependent: :delete
    add_foreign_key :review_answers, :review_questions, column: :review_question_id, dependent: :delete
  end
end
