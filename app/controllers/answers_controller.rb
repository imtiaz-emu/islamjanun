class AnswersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  layout 'member'

  respond_to :js
  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.new(answer_params)
    @answer.question_id = @question.id
    @answer.save
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
      @question = Question.find(params[:question_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:description, :question_id, :user_id, :accepted)
    end
end
