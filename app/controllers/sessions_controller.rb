class SessionsController < ApplicationController
  def create
  
    user = User.from_omniauth(env["omniauth.auth"])

    session[:user_id] = user.id
    
    if user.approved != "Yes"
      redirect_to edit_user_path(user)
    elsif user.matches.empty?
      redirect_to user_path(user), notice: "Thanks for signing in. We are currently identifying matches for you. Please check back soon!"
    else
      redirect_to user_path(user), notice: "Signed in! Click on Current Match to see your match."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to dashboard_index_path, notice: "Signed out!"
  end
end
