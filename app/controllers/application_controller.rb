class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # def authenticate_admin_user!
  #   redirect_to new_user_session_path unless current_user.try(:is_admin?)
  # end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = exception.message

    if current_user.present?
      redirect_to root_path
    else
      session[:user_return_to] = request.url
      redirect_to new_user_session_path
    end

  end

  def admin?
    current_user.present? && current_user.is_admin?
  end

  def moderator?
    current_user.present? && current_user.is_moderator?
  end

  def authenticate_admin_user!
    redirect_to root_path unless current_user.try(:is_admin?)
  end
end
