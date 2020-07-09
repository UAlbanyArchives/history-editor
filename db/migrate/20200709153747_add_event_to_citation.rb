class AddEventToCitation < ActiveRecord::Migration[5.2]
  def change
    add_reference :citations, :event, foreign_key: true
  end
end
