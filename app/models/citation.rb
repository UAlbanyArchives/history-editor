class Citation < ApplicationRecord
	belongs_to :events, optional: true

	validates :link, presence: true
	validate :link_has_correct_format

	def get_thumbnail
		return unless link.present?

		# Extract parts of the link with regex
		match = link.match(%r{https://archives\.albany\.edu/description/catalog/(.+)aspace_(\w+)$})
		return unless match

		collection_number = match[1].tr('-', '.')
		object_id = match[2]

		# Construct thumbnail URL
		url = "https://media.archives.albany.edu/#{collection_number}/#{object_id}/thumbnail.jpg"
		self.file = url
	end

	def link_has_correct_format
	  return if link.blank?

	  expected_prefix = 'https://archives.albany.edu/description/catalog'
	  unless link.strip.downcase.start_with?(expected_prefix)
		errors.add(:link, "Invalid citation link for record ID #{id}: #{link}. Event ID: #{event_id || '(none)'}. Must start with #{expected_prefix}")
	  end
	end
end
