class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.references :project, index: true
      t.references :server, index: true
      t.string :name
      t.string :role
      t.string :stage
      t.string :branch
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
