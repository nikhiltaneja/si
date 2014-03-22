class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    if user.matches.empty?
      redirect_to user_path(user), notice: "Signed in!"
    else
      redirect_to user_match_path(current_user, current_user.current_match), notice: "Signed in!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
