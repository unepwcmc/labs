class ChangePercentageLiveTimeFieldsInProjects < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :percentage_live_time_informatics
    remove_column :projects, :percentage_live_time_codesign
    remove_column :projects, :percentage_live_time_agency

    add_column :projects, :project_leading_style, :text
  end
end
