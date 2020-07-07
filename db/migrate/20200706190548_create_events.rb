class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.date :date
      t.string :display_date
      t.string :citation_text
      t.string :citation_link
      t.string :citation_page
      t.text :citation_description
      t.string :content_link
      t.string :thumb

      t.timestamps
    end
  end
end
