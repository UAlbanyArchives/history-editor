class Subject < ApplicationRecord
	has_and_belongs_to_many :events

	validates :name, uniqueness: { case_sensitive: false }
	validate :media_has_correct_format, if: -> { representative_media.present? }

	def media_has_correct_format
  		errors.add(:representative_media, "Invalid representative media link.") unless representative_media.downcase.start_with?('https://archives.albany.edu/description/catalog')
	end
end
