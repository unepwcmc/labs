class AddLevelOfInvolvementFieldToKpi < ActiveRecord::Migration[5.0]
  def change
    add_column :kpis, :level_of_involvement, :text
  end
end
