class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  layout 'member'
  respond_to :js


  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @commentable = find_commentable
    @commentable.comments.create(comment_params)
    @comments = @commentable.comments.order('created_at DESC')
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment.update(comment_params)
    @comments = @comment.commentable.comments.order('created_at DESC')
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @commentable = @comment.commentable
    @comments = @commentable.comments.order('created_at DESC')
    @comment.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:description, :user_id, :q_id, :a_id)
  end

  def find_commentable
    if params[:comment][:a_id].present?
      return Answer.find(params[:comment][:a_id])
    else
      return Question.find(params[:comment][:q_id])
    end
  end

end
