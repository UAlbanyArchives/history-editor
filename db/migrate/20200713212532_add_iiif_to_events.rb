class AddIiifToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :iiif, :boolean
  end
end
