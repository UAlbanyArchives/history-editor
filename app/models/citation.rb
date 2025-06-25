class Citation < ApplicationRecord
	belongs_to :events, optional: true

	validates :link, presence: true
	validate :link_has_correct_format

	def link_has_correct_format
	  return if link.blank?

	  expected_prefix = 'https://archives.albany.edu/description/catalog'
	  unless link.strip.downcase.start_with?(expected_prefix)
	    errors.add(:link, "Invalid citation link for record ID #{id}: #{link}. Event ID: #{event_id || '(none)'}. Must start with #{expected_prefix}")
	  end
	end
end
