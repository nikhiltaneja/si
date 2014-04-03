class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  helper_method :current_user
  helper_method :correct_user?
  helper_method :admin?
  helper_method :matches?
  helper_method :approved?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to user_path(current_user), alert: "Access denied."
    end
  end

  def admin?
    current_user.admin
  end

  def check_admin?
    if !current_user.admin
      redirect_to user_path(current_user)
    end
  end

  def matches?
    if current_user.matches.empty?
      redirect_to user_path(current_user), notice: "Thanks for signing in. We are currently identifying matches for you. Please check back soon!"
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to dashboard_index_path
    end
  end

  def approved?
    if current_user.approved != "Yes"
      redirect_to user_path(current_user)
    end
  end

  def logged_in?
    if current_user
      redirect_to user_path(current_user)
    end
  end
end
