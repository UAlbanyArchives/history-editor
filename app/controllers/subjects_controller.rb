class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.all
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects
  # POST /subjects.json
  def create
    strip_params
    get_file
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    strip_params
    get_file
    
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    def strip_params
      params[:subject][:representative_media] = params[:subject][:representative_media].split('?')[0]
    end

    def get_file
      require 'net/http'
      require 'json'

      if params[:subject][:representative_media]
        url = URI.parse(params[:subject][:representative_media] + "?format=jsonld")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url.request_uri)

        response = http.request(request)
        result = JSON.parse(response.body)
        fileSetID = []
        result["@graph"].each do |thing|
          if thing.key?("ore:proxyFor")
            fileSetID << thing["ore:proxyFor"]["@id"].split("archives.albany.edu/catalog/")[1]
          end
        end
        fileURL = "https://archives.albany.edu/downloads/" + fileSetID[0]
        params[:subject][:file] = fileURL
        end
    end


    # Only allow a list of trusted parameters through.
    def subject_params
      params.require(:subject).permit(:name, :representative_media, :file)
    end
end
