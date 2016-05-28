class HomeController < ApplicationController
  def index
  end

  def all_tags
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name)
    respond_to do |format|
      format.json { render :json => @tags }
    end
  end

  def local_switcher
    if params[:locale_set]
      I18n.locale = params[:locale_set].to_sym
      set_session_and_redirect
    end
  end

  private
  def set_session_and_redirect
    session[:locale] = I18n.locale
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to :root
  end

end
