class QuestionsController < ApplicationController
  respond_to :json
  before_action :set_question, only: [:update, :destroy, :show]
  before_action :set_presentation, only: [:index, :create]

  # GET /presentations/1/questions.json
  def index
    @questions = @presentation.questions.all.sort_by(&:slide)
    render json: @questions
  end

  # GET /presentations/1/questions/1.json
  def show
    render json: @question
  end

  # POST /presentations/1/questions.json
  def create
    @question = @presentation.questions.new(question_params)

    respond_to do |format|
      if @question.save
        format.json { render json: @question }
      else
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /presentations/1/questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.json { render json: @question }
      else
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1/questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      set_presentation
      @question = @presentation.questions.find(params[:id])
    end

    def set_presentation
      @presentation = Presentation.find(params[:presentation_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:body, :slide, :presentation_id, :choices => [])
    end
end
