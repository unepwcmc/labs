class ChangeManualYearlyUpdatesToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :manual_yearly_updates, :float
  end
end
