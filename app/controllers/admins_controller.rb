class AdminsController < ApplicationController
  before_action :check_admin?

  def index
    users = User.all
    @eligible_users  = users.select do |user|
      if user.current_match
        (Time.now - user.current_match.created_at) > 86400 #one day
      else
        true
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @potential_matches = @user.find_potential_matches

    @shared = @potential_matches.collect do |potential_match|
      @user.shared_connections(potential_match.id).count
    end
  end

  def requests
    @users = User.where(approved: "pending")
  end
end
