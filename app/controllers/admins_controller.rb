class AdminsController < ApplicationController
  before_action :check_admin?

  def index
    users = User.where(approved: "Yes")
    @eligible_users  = users.select do |user|
      user.eligible_for_new_match?
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

  def matches
    @all_matches = Match.all
    @true_status = Match.where(match_status: true)
  end
end
