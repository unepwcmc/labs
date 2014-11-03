class AddPivotalAndTrelloIDs < ActiveRecord::Migration
  def change
    add_column :projects, :pivotal_tracker_ids, :text, array: true, default: []
    add_column :projects, :trello_ids, :text, array: true, default: []
  end
end
