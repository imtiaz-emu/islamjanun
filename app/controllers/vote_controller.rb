class VoteController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!

  layout 'member'
  respond_to :js

  def upvote
    @upvotable = find_upvotable
    if @upvotable.user != current_user
      user_upvote = @upvotable.upvotes.find_by(:user_id => current_user.id)
      user_downvote = @upvotable.downvotes.find_by(:user_id => current_user.id)
      if user_upvote.present?
        user_upvote.destroy
      else
        @upvotable.upvotes.create(:user_id => current_user.id)
        if user_downvote.present?
          user_downvote.destroy
        end
      end
    else
      @error = "You can't vote your own #{@upvotable.model_name}"
    end
  end

  def downvote
    @downvotable = find_downvotable
    if @downvotable.user != current_user
      user_downvote = @downvotable.downvotes.find_by(:user_id => current_user.id)
      user_upvote = @downvotable.upvotes.find_by(:user_id => current_user.id)
      if user_downvote.present?
        user_downvote.destroy
      else
        @downvotable.downvotes.create(:user_id => current_user.id)
        if user_upvote.present?
          user_upvote.destroy
        end
      end
    else
      @error = "You can't vote your own #{@downvotable.model_name}"
    end
  end

  private

  def find_upvotable
    if params[:a_id].present?
      return Answer.find(params[:a_id])
    else
      return Question.find(params[:q_id])
    end
  end

  def find_downvotable
    if params[:a_id].present?
      Answer.find(params[:a_id])
    else
      Question.find(params[:q_id])
    end
  end

end
