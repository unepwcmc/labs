class AddConstraintsToServers < ActiveRecord::Migration
  def change
    add_foreign_key :installations, :servers, dependent: :delete
  end
end
