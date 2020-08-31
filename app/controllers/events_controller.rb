class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_paper_trail_whodunnit

  def clean_clickref

    if self.url
      require 'addressable/uri'

      uri = Addressable::URI.parse(self.url)
      params = uri.query_values

      if params
        uri.query_values = params.except('clickref')
        self.url = uri.to_s
      end

    end
  end

  # GET /events
  # GET /events.json
  def index
    if params[:editor]
      #@edited_by = Event.all.each { |event| event.versions[0].whodunnit == params[:editor] }
      @edited_by = []
      Event.all.each do |event|
        if event.versions.last.whodunnit == params[:editor]
          @edited_by << event
        end
      end
      @events = Event.where(id: @edited_by.map(&:id)).order("updated_at DESC")
    elsif params[:unedited]
      @events = Event.where(formatted_correctly: nil).or(Event.where(formatted_correctly: false))
    else
      @events = Event.all
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    strip_params
    get_file
    citation_fixes
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    strip_params
    get_file
    citation_fixes
    
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def citation_fixes
      require 'net/http'
      require 'json'

      if params[:event][:citations_attributes]
        params[:event][:citations_attributes].each do |cite|
          cite[1][:link] = cite[1][:link].split('?')[0]
          url = URI.parse(cite[1][:link] + "?format=jsonld")
          
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Get.new(url.request_uri)

          response = http.request(request)
          result = JSON.parse(response.body)
          fileSetID = []
          label = ""
          result["@graph"].each do |thing|
            if thing.key?("ore:proxyFor")
              fileSetID << thing["ore:proxyFor"]["@id"].split("archives.albany.edu/catalog/")[1]
            end
            if thing.key?("dc:title") and label == ""
              label = thing["dc:title"]
            end
          end
          fileURL = "https://archives.albany.edu/downloads/" + fileSetID[0]
          cite[1][:file] = fileURL
          unless cite[1][:text].present? or label == ""
            cite[1][:text] = label
          end
        end
      end
    end

    def strip_params
      params[:event][:representative_media] = params[:event][:representative_media].split('?')[0]
    end

    def get_file
      require 'net/http'
      require 'json'
      
      if params[:event][:representative_media]
        url = URI.parse(params[:event][:representative_media] + "?format=jsonld")
      elsif params[:event][:citations_attributes]
        cite_param = params[:event][:citations_attributes]
        cite_key = cite_param.as_json.first.first
        url = URI.parse(cite_param[cite_key][:link].split('?')[0] + "?format=jsonld")
      elsif @event.present?
        if @event.citations.present?
            url = URI.parse(@event.citations[0].link + "?format=jsonld")
        end
      end
      if url
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url.request_uri)

        response = http.request(request)
        result = JSON.parse(response.body)
        fileSetID = []
        iiif_switch = false
        result["@graph"].each do |thing|
          if thing.key?("ore:proxyFor")
            fileSetID << thing["ore:proxyFor"]["@id"].split("archives.albany.edu/catalog/")[1]
          end
          if thing.key?("dc:type") and thing["dc:type"] == "Image"
            iiif_switch = true
          end
        end
        fileURL = "https://archives.albany.edu/downloads/" + fileSetID[0]
        params[:event][:file] = fileURL
        params[:event][:iiif] = iiif_switch
      else
        if @event.present?
          unless @event.citations.present? or @event.representative_media.present?
            params[:event][:file] = nil
            params[:event][:iiif] = nil
          end
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :date, :display_date, :citation_description, :representative_media, :file, :iiif, :internal_note, :formatted_correctly, :content_confirmed, :published, :subject_ids => [], citations_attributes: [:id, :link, :text, :page, :file, :_destroy])
    end
end
