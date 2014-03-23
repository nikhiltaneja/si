class AdminsController < ApplicationController
  before_action :admin?

  def index
    @eligible_users = []
    @users = User.all
    @users.each do |user|
      if (Time.now - user.current_match.created_at) > 10 #need to change to one day
        @eligible_users << user
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @location_matches = @user.location_matches
    @shared = []
    @location_matches.each do |user_l|
      @shared << @user.shared_connections(user_l).count
    end
    
  end

end
