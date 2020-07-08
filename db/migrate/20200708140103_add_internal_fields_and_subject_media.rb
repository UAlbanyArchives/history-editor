class AddInternalFieldsAndSubjectMedia < ActiveRecord::Migration[5.2]
  def change
  	add_column :events, :internal_note, :text
  	add_column :events, :content_confirmed, :boolean
  	add_column :events, :formatted_correctly, :boolean
  	rename_column :events, :content_link, :representative_media
  	add_column :subjects, :representative_media, :string
  	add_column :subjects, :thumb, :string
  end
end
