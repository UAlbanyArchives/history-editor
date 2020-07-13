json.extract! event, :id, :title, :description, :date, :display_date, :citation_description, :representative_media, :file, :iiif, :created_at, :updated_at
json.url event_url(event, format: :json)
