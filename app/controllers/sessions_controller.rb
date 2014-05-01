class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    
    if user.approved != "Yes"
      redirect_to edit_user_path(user)
    elsif user.matches.empty?
      redirect_to user_path(user), notice: "Thanks for signing in. We are currently identifying potential introductions for you. Please check back soon!"
    else
      redirect_to user_match_path(user, user.current_match.id), notice: "Signed in! Here is your current intro."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to dashboard_index_path, notice: "Signed out!"
  end
end
