class AddUpdatedByToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :updated_by, :integer
  end
end
