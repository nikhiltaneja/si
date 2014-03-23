class AdminsController < ApplicationController

  def index
    @eligible_users = []
    @users = User.all
    @users.each do |user|
      if (Time.now - user.current_match.created_at) > 10
        @eligible_users << user
      end
    end
  end

  def show
    @user = User.find(params[:id])
    
  end

end
