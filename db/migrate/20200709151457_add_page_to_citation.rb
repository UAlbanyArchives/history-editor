class AddPageToCitation < ActiveRecord::Migration[5.2]
  def change
  	add_column :citations, :page, :integer
  end
end
