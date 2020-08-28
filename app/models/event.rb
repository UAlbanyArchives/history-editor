class Event < ApplicationRecord
	has_and_belongs_to_many :subjects 
	accepts_nested_attributes_for :subjects
	#validates_associated :subjects
	has_many :citations , dependent: :destroy
	accepts_nested_attributes_for :citations, allow_destroy: true
	validates_associated :citations
    
    before_validation :titlecase_title

	has_paper_trail

	after_commit :index_data_in_solr, on: [:create, :update]
	before_destroy :remove_data_from_solr

	validates :title, :description, :date, presence: true
	validates :title, uniqueness: { case_sensitive: false }

	validate :media_has_correct_format, if: -> { representative_media.present? }
    

    def titlecase_title
      title_confirmation.try(:titlecase!)
      title.try(:titlecase!)
    end
	
	def media_has_correct_format
  		errors.add(:representative_media, "Invalid representative media link.") unless representative_media.downcase.start_with?('https://archives.albany.edu/concern/')
	end

	def to_solr
		solr_subjects = []
		self.subjects.each do |subj|
			solr_subjects << subj.name
		end
		solr_citation_links = []
		solr_citation_text = []
		solr_citation_pages = []
		solr_citation_files = []
		self.citations.each do |cite|
			solr_citation_links << cite.link
			solr_citation_text << cite.text
			solr_citation_pages << cite.page
			solr_citation_files << cite.file
		end
		if display_date.present?
	    	{
	      	"title" => title, "description" => description, "date" => date.strftime("%Y-%m-%d"), "display_date" => display_date,
	      	"subjects" => solr_subjects, "citation_description" => citation_description, "citation_links" => solr_citation_links, "citation_text" => solr_citation_text, "citation_pages" => solr_citation_pages, "citation_files" => solr_citation_files,
	     	 "representative_media" => representative_media, "file" => file, "iiif" => iiif, "id" => id
	    	}
		else
			{
	      	"title" => title, "description" => description, "date" => date.strftime("%Y-%m-%d"), "display_date" => date.strftime("%Y %B %e"),
	      	"subjects" => solr_subjects, "citation_description" => citation_description, "citation_links" => solr_citation_links, "citation_text" => solr_citation_text, "citation_pages" => solr_citation_pages, "citation_files" => solr_citation_files,
	      	"representative_media" => representative_media, "file" => file, "iiif" => iiif,"id" => id
	    	}
		end
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
