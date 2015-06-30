class RenameSelectedOptionToDone < ActiveRecord::Migration
  def change
    rename_column :review_answers, :selected_option, :done
  end
end
