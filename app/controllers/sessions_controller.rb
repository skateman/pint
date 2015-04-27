class SessionsController < ApplicationController
  respond_to :json
  before_action :set_session, only: [:show, :update, :destroy, :answer]

  # GET /sessions/1.json
  def show
    render json: build_hash(@session)
  end

  # POST /sessions/1/answer
  def answer
    @answer = @session.answers.new(:number => params[:number], :question => @session.current_question)
    respond_to do |format|
      if @answer.save
        format.json { render json: build_hash(@session) }
      else
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /sessions.json
  def create
    @session = Session.new(session_params)

    respond_to do |format|
      if @session.save
        format.json { render json: build_hash(@session) }
      else
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions/1.json
  def update
    respond_to do |format|
      if @session.update(session_params)
        format.json { render json: build_hash(@session) }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1.json
  def destroy
    @session.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:session).permit(:name, :presentation_id, :slide)
    end

    def build_hash(s)
      results = s.aggregate
      {
        :id           => s.id,
        :question     => s.current_question,
        :answers      => results.map {|_,v| v.to_i}.reduce(:+),
        :results      => results,
        :slide        => s.slide,
        :presentation => s.presentation
      }
    end
end
