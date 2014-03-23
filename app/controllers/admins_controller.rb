class AdminsController < ApplicationController
  before_action :admin?

  def index
    users = User.all
    @eligible_users  = users.select do |user|
      if user.current_match
        (Time.now - user.current_match.created_at) > 10 #need to change to one day
      end
    end
  end

  def show
    @user = User.find(params[:id])

    users_same_location = @user.location_matches
    removed_previous_matches = @user.remove_previous_matches(users_same_location)
    @potential_matches = @user.remove_oneself(removed_previous_matches)

    @shared = []
    @potential_matches.each do |potential_match|
      @shared << @user.shared_connections(potential_match).count
    end

    # users_same_location = @user.location_matches
    # @shared_counts = users_same_location.collect do |user_same_location|
    #   @user.shared_connections(user_same_location).count
    # end
  end
end
