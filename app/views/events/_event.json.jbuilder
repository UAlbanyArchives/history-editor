json.extract! event, :id, :title, :description, :date, :display_date, :citation_text, :citation_link, :citation_page, :citation_description, :content_link, :thumb, :created_at, :updated_at
json.url event_url(event, format: :json)
