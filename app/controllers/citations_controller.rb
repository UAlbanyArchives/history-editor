class CitationsController < ApplicationController
  before_action :set_citation, only: [:show, :edit, :update, :destroy]
  include ApplicationHelper

  # GET /citations
  # GET /citations.json
  def index
    @citations = Citation.all
  end

  # GET /citations/1
  # GET /citations/1.json
  def show
  end

  # GET /citations/new
  def new
    @citation = Citation.new
  end

  # GET /citations/1/edit
  def edit
  end

  # POST /citations
  # POST /citations.json
  def create
    get_file
    @citation = Citation.new(citation_params)

    respond_to do |format|
      if @citation.save
        format.html { redirect_to @citation, notice: 'Citation was successfully created.' }
        format.json { render :show, status: :created, location: @citation }
      else
        format.html { render :new }
        format.json { render json: @citation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /citations/1
  # PATCH/PUT /citations/1.json
  def update
    get_file
    respond_to do |format|
      if @citation.update(citation_params)
        format.html { redirect_to @citation, notice: 'Citation was successfully updated.' }
        format.json { render :show, status: :ok, location: @citation }
      else
        format.html { render :edit }
        format.json { render json: @citation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /citations/1
  # DELETE /citations/1.json
  def destroy
    @citation.destroy
    respond_to do |format|
      format.html { redirect_to citations_url, notice: 'Citation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_citation
      @citation = Citation.find(params[:id])
    end

    def strip_params
      params[:citation][:link] = params[:citation][:link].split('?')[0]
    end

    def get_file
      
      if params[:citation][:link]
        file = transform_thumbnail(params[:citation][:link])
        params[:citation][:file] = file
      end
    end

    # Only allow a list of trusted parameters through.
    def citation_params
      params.require(:citation).permit(:text, :link, :file)
    end
end
