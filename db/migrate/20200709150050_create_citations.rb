class CreateCitations < ActiveRecord::Migration[5.2]
  def change
    create_table :citations do |t|
      t.string :text
      t.string :link
      t.string :file

      t.timestamps
    end
  end
end
