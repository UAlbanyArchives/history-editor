# lib/tasks/migrate.rake
require 'net/http'
require 'uri'
require 'json'

namespace :arclight do
  desc "Update representative_media and citation links using Solr lookup"
  task migrate: :environment do
    base_url = 'https://solr2020.library.albany.edu:8984/solr/arclight-1.4_dao/select'

    def lookup_new_id(legacy_id, base_url)
      return nil if legacy_id.blank?

      uri = URI(base_url)
      params = {
        fq: "dado_legacy_id_ssim:#{legacy_id}",
        q: "*:*",
        wt: "json"
      }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      return nil unless response.is_a?(Net::HTTPSuccess)

      body = JSON.parse(response.body)
      doc = body.dig("response", "docs")&.first
      return nil unless doc && doc["id"]

      "https://archives.albany.edu/description/catalog/#{doc["id"]}"
    rescue => e
      puts "Lookup failed for legacy ID #{legacy_id}: #{e.message}"
      nil
    end

    def transform_url(original_url)
      if original_url =~ %r{catalog/([^/]+)aspace_([0-9a-f]+)}
        collection_id = $1
        object_id = $2.sub(/^aspace_/, '')
        "https://media.archives.albany.edu/#{collection_id.gsub('-', '.')}/#{object_id}/thumbnail.jpg"
      else
        nil
        #raise "Unexpected URL format: #{original_url}"
      end
    end

    ### Update Citations ###
    Citation.find_each do |citation|
      next unless citation.link.present?

      legacy_id = citation.link.split('/').last
      new_id = lookup_new_id(legacy_id, base_url)

      if new_id && citation.link != new_id
        puts "Updating Citation #{citation.id} link: #{citation.link} → #{new_id}"
        citation.link = new_id
        citation.file = transform_url(new_id)
        citation.save!
      end
    end

    ### Update Events ###
    Event.find_each do |event|
      next if event.representative_media.blank?

      legacy_id = event.representative_media.split('/').last
      new_id = lookup_new_id(legacy_id, base_url)
      file = transform_url(new_id)

      if new_id && event.representative_media != new_id
        puts "Updating Event #{event.id}: #{event.representative_media} → #{new_id}"
        event.representative_media = new_id
        event.file = file
        event.save!
      end
    end

    ### Update Subjects ###
    Subject.find_each do |subject|
      updated = false

      # Update representative_media
      if subject.representative_media.present?
        legacy_id = subject.representative_media.split('/').last
        new_id = lookup_new_id(legacy_id, base_url)
        file = transform_url(new_id)

        if new_id && subject.representative_media != new_id
          puts "Updating Subject #{subject.id} representative_media: #{subject.representative_media} → #{new_id}"
          subject.representative_media = new_id
          subject.file = file
          updated = true
        end
      end

      subject.save! if updated
    end

  end
end
