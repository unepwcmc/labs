class DeleteColumnsAndRelationshipsTables < ActiveRecord::Migration
  def up
    disable_extension :hstore
    remove_foreign_key :columns, :models
    remove_foreign_key :relationships, column: 'left_model_id'
    remove_foreign_key :relationships, column: 'right_model_id'
    drop_table :columns
    drop_table :relationships
  end

  def down
    enable_extension :hstore

    create_table :columns do |t|
      t.belongs_to :model, index: true
      t.string :name, null: false
      t.string :col_type, null: false
      t.timestamps null: false
    end

    create_table :relationships do |t|
      t.integer :left_model_id, null: false
      t.integer :right_model_id, null: false
      t.string :rel_type, null: false
      t.string :name, null: false
      t.hstore :options
      t.timestamps null: false
    end

    add_foreign_key :columns, :models
    add_foreign_key :relationships, :models, column: 'left_model_id'
    add_foreign_key :relationships, :models, column: 'right_model_id'
  end
end
