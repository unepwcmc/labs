class CreateKpis < ActiveRecord::Migration[5.0]
  def change
    create_table :kpis do |t|
      t.integer :singleton_guard, default: 0, null: false

      t.float :percentage_currently_active_products
      t.float :total_income, precision: 2
      t.integer :bugs_backlog_size, default: 0
      t.float :percentage_projects_with_kpis
      t.float :percentage_secure_projects
      t.float :percentage_projects_with_ci
      t.float :percentage_projects_documented

      t.timestamps
    end
    add_index :kpis, :singleton_guard, :unique => true
  end
end
