class CreateDatabaseDomainForProjects < ActiveRecord::Migration
  def up
    enable_extension :hstore
    create_table :domains do |t|
      t.belongs_to :project
      t.timestamps null: false
    end

    create_table :models do |t|
      t.belongs_to :domain, index: true
      t.string :name, null: false
      t.timestamps null: false
    end

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
      t.hstore :options
      t.timestamps null: false
    end

    add_foreign_key :models, :domains
    add_foreign_key :columns, :models
    add_foreign_key :relationships, :models, column: 'left_model_id'
    add_foreign_key :relationships, :models, column: 'right_model_id'
  end

  def down
    disable_extension :hstore
    remove_foreign_key :models, :domains
    remove_foreign_key :columns, :models
    remove_foreign_key :relationships, column: 'left_model_id'
    remove_foreign_key :relationships, column: 'right_model_id'
    drop_table :domains
    drop_table :models
    drop_table :columns
    drop_table :relationships
  end
end
