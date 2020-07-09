class Event < ApplicationRecord
	has_and_belongs_to_many :subjects 
	accepts_nested_attributes_for :subjects
	#validates_associated :subjects

	after_commit :index_data_in_solr, on: [:create, :update]
	before_destroy :remove_data_from_solr

	#validates :title, :description, :date, presence: true
	#validates :title, uniqueness: { case_sensitive: false }

	validates :citation_link, presence: true, if: -> { citation_page.present? }
	validates :citation_link, presence: true, if: -> { citation_text.present? }
	validates :citation_link, presence: true, if: -> { citation_description.present? }
	validates :representative_media, presence: false, if: -> { citation_link.present? }

	validate :citation_has_correct_format, if: -> { citation_link.present? }
	validate :media_has_correct_format, if: -> { representative_media.present? }

	def citation_has_correct_format
  		errors.add(:citation_link, "Invalid citation link.") unless citation_link.downcase.start_with?('https://archives.albany.edu/concern/')
	end
	def media_has_correct_format
  		errors.add(:representative_media, "Invalid representative media link.") unless representative_media.downcase.start_with?('https://archives.albany.edu/concern/')
	end

	def to_solr
		solr_subjects = []
		self.subjects.each do |subj|
			solr_subjects << subj.name
		end
	    {
	      "title" => title, "description" => description, "date" => date.strftime("%Y-%m-%d"),"date_formatted" => date.strftime("%Y %B%e"), "display_date" => display_date,
	      "subjects" => solr_subjects, "citation_text" => citation_text, "citation_link" => citation_link, "citation_page" => citation_page.to_s,
	      "citation_description" => citation_description, "representative_media" => representative_media, "file" => file, "id" => id
	    }
	  end

	  def index_data_in_solr
	    SolrService.add(to_solr)
	    SolrService.commit
	  end

	  def remove_data_from_solr
	    SolrService.delete_by_id(id)
	    SolrService.commit
	  end

end
