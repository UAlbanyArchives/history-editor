class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_paper_trail_whodunnit
  include ApplicationHelper

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
      @events = Event.where(updated_by: params[:editor].to_i).order("updated_at DESC")
    elsif params[:unconfirmed]
      @events = Event.where(content_confirmed: false)
    elsif params[:unpublished]
      @events = Event.where(published: false)
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
    
    @event.updated_by = current_user.id
    
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

    def strip_params
      params[:event][:representative_media] = params[:event][:representative_media].split('?')[0]
    end

    def get_file
      
      if params[:event][:representative_media]
        file = transform_thumbnail(params[:event][:representative_media])
      elsif @event.present?
        if @event.citations.present?
          file = transform_thumbnail(@event.citations[0].link)
        end
      end
      if file
        params[:event][:file] = file
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :date, :display_date, :citation_description, :representative_media, :file, :iiif, :internal_note, :formatted_correctly, :content_confirmed, :published, :subject_ids => [], citations_attributes: [:id, :link, :text, :page, :file, :_destroy])
    end
end
