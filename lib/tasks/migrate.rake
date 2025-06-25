# lib/tasks/migrate.rake
require 'net/http'
require 'uri'
require 'json'

namespace :arclight do
  desc "Update representative_media and citation links using Solr lookup"

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

    unless response.is_a?(Net::HTTPSuccess)
      puts "Failed request for legacy ID #{legacy_id}: HTTP #{response.code} #{response.message}"
      return nil
    end

    body = JSON.parse(response.body)
    doc = body.dig("response", "docs")&.first

    unless doc && doc["id"]
      unless legacy_id.include? "aspace_"
        puts "No document found for legacy ID #{legacy_id} (response OK)"
      end
      return nil
    end

    "https://archives.albany.edu/description/catalog/#{doc["id"]}"
  rescue => e
    puts "Lookup failed for legacy ID #{legacy_id}: #{e.message}"
    nil
  end

  task check: :environment do
    puts "Checking citations..."
    Citation.find_each do |citation|
      unless citation.valid?
        unless citation.valid?
          puts citation.errors.full_messages
        end
      end
    end
  end

  task convert: :environment do
    puts "Converting citations..."
    Citation.find_each do |citation|
      unless citation.valid?
        unless citation.text.include? "Albany Student Press"
          puts "#{citation.attributes['event_id']} #{citation.text}"
        else
          query_text = citation.text.sub(/,\s*p\.\s*\d+\s*$/i, '')

          # Build URL
          base_url = 'https://archives.albany.edu/catalog'
          params = {
            utf8: "✓",
            search_field: "all_fields",
            q: query_text,
            format: "json"
          }
          uri = URI(base_url)
          uri.query = URI.encode_www_form(params)

          response = Net::HTTP.get_response(uri)

          unless response.is_a?(Net::HTTPSuccess)
            puts "HTTP #{response.code} for '#{query_text}'"
            next
          end

          data = JSON.parse(response.body)
          result = data["data"]&.first

          if result
            new_link = "https://archives.albany.edu/concern/#{result['type'].downcase}s/#{result['id']}"
            citation.link = new_link
            #puts new_link
            citation.save(validate: false)
          else
            puts "No results found for '#{query_text}'"
          end

        end
      end
    end
  end

  task migrate: :environment do
    base_url = 'https://solr2020.library.albany.edu:8984/solr/arclight-1.4_dao/select'

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
    puts "Updating citations..."
    Citation.find_each do |citation|
      unless citation.valid?
        puts citation.errors.full_messages
      end
      if citation.link.present?

        legacy_id = citation.link.split('/').last
        new_id = lookup_new_id(legacy_id, base_url)

        if new_id && citation.link != new_id
          puts "Updating Citation #{citation.id} link: #{citation.link} → #{new_id}"
          citation.link = new_id
          citation.file = transform_url(new_id)
          citation.save!
        end
      else
        citation.save!
      end
    end

    ### Update Events ###
    puts "Updating events..."
    Event.find_each do |event|
      if event.representative_media
        legacy_id = event.representative_media.split('/').last
        new_id = lookup_new_id(legacy_id, base_url)
        file = transform_url(new_id)

        if new_id && event.representative_media != new_id
          puts "Updating Event #{event.id}: #{event.representative_media} → #{new_id}"
          event.representative_media = new_id
          event.file = file
          event.save!
        end
      elsif event.citations.length > 0
        event.file = event.citations[0].file
        event.save!        
      end
    end

    ### Update Subjects ###
    puts "Updating subjects..."
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
