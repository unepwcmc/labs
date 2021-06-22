class RemoveGaViewIdFromProduct < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :ga_view_id
  end
end
