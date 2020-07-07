class Event < ApplicationRecord
	has_many :subjects
	validates_associated :subjects

	validates :title, :description, :date, presence: true
	validates :title, uniqueness: { case_sensitive: false }

	validates :citation_link, presence: true, if: -> { citation_page.present? }
	validates :citation_link, presence: true, if: -> { citation_text.present? }
	validates :citation_link, presence: true, if: -> { citation_description.present? }
	validates :content_link, presence: false, if: -> { citation_link.present? }

	validate :citation_has_correct_format
	validate :content_has_correct_format, if: -> { content_link.present? }

	def citation_has_correct_format
  		errors.add(:citation_link, "Invalid citation link.") unless citation_link.downcase.start_with?('https://archives.albany.edu/concern/')
	end
	def content_has_correct_format
  		errors.add(:content_link, "Invalid content link.") unless content_link.downcase.start_with?('https://archives.albany.edu/concern/')
	end

end
