class PresentationsController < ApplicationController
  respond_to :json
  before_action :set_presentation, only: [:show, :update, :destroy]

  # GET /presentations
  # GET /presentations.json
  def index
    @presentations = Presentation.all
    render json: @presentations
  end

  # GET /presentations/1
  # GET /presentations/1.json
  def show
    render json: @presentation
  end

  # POST /presentations
  # POST /presentations.json
  def create
    @presentation = Presentation.new(presentation_params)

    respond_to do |format|
      if @presentation.save
        @presentation.convert
        format.json { redirect_to '/' }
      else
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /presentations/1
  # PATCH/PUT /presentations/1.json
  def update
    respond_to do |format|
      if @presentation.update(presentation_params)
        format.json { render json: @presentation }
      else
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @presentation.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_presentation
      @presentation = Presentation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def presentation_params
      params.require(:presentation).permit(:title, :description, :pdf)
    end
end
