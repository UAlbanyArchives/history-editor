class ChangeThumbToFile < ActiveRecord::Migration[5.2]
  def change
  	rename_column :events, :thumb, :file
  	rename_column :subjects, :thumb, :file
  end
end
