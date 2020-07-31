class Citation < ApplicationRecord
	belongs_to :events, optional: true

	validates :link, presence: true
	validate :link_has_correct_format

	def link_has_correct_format
  		errors.add(:link, "Invalid citation link.") unless link.downcase.start_with?('https://archives.albany.edu/concern/')
	end
end
