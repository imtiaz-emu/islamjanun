class QuestionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy, :approval]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_question, only: [:edit, :update, :destroy]

  impressionist :actions=>[:show], unique: [:session_hash]

  layout 'member'
  # GET /questions
  # GET /questions.json
  def index
    if params[:t].present?
      @questions =  Question.includes(:answers, :user => :profile).order('updated_at DESC').approved_questions.tagged_with(params[:t])
    else
      @questions = Question.includes(:answers, :user => :profile).order('updated_at DESC').approved_questions
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.includes(:answers, :user => :profile).find(params[:id])
    if @question.approved || moderator?
      @no_of_view = @question.impressionist_count
      @comments = @question.comments.includes(:user => :profile)
    else
      redirect_to root_path
    end
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
    if @question.user != current_user
      redirect_to questions_path
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = current_user.questions.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created and waiting for approval.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pending_questions
    if moderator? || admin?
      @questions = Question.includes(:answers, :user => :profile).order('updated_at DESC').unapproved_questions
    else
      redirect_to root_path
    end
  end

  def approval
    @question = Question.find(params[:question_id])
    if moderator? || admin?
      @question.update_column(:approved, @question.approved ? false : true)
      redirect_to :back
    else
      redirect_to root_path
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :description, :tag_list)
    end
end
