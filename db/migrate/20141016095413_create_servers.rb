class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name
      t.string :domain
      t.string :username
      t.string :admin_url
      t.string :os
      t.text :description

      t.timestamps
    end
  end
end
