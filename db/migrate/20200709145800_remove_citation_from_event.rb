class RemoveCitationFromEvent < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :citation_link, :string
    remove_column :events, :citation_text, :string
    remove_column :events, :citation_page, :integer
  end
end
