module Admin
  class DashboardController < ApplicationController
    before_filter :authenticate_user!
    layout 'admin'

    def index
      @users = User.all
      @questions = Question.unapproved_questions.order('updated_at DESC')
    end
  end
end



