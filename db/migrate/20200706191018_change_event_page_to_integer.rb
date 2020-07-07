class ChangeEventPageToInteger < ActiveRecord::Migration[5.2]
  def change
  	 change_column :events, :citation_page, :integer
  end
end
