class AdminsController < ApplicationController
  before_action :check_admin?

  def index
    users = User.where(approved: "Yes").where(deleted: false).where(active: true)
    @eligible_users = users.select do |user|
      user.eligible_for_new_match?
    end
  end

  def show
    @user = User.find(params[:id])
    @potential_matches = @user.find_potential_matches

    @shared_connections = []
    @shared_skills = []
    @shared_industry_interests = []

    @potential_matches.each do |potential_match|
      @shared_connections << @user.shared_connections(potential_match.id).count
      @shared_skills << @user.compare_skills_count(potential_match)
      @shared_industry_interests << @user.compare_industry_interests_count(potential_match)
    end
  end

  def requests
    @users = User.where(approved: "pending").where(deleted: false)
  end

  def matches
    @all_users_count = User.all.count
    @all_matches = Match.all
    @successful_matches_count = @all_matches.where(match_status: true).count
    @first_user_yes_count = @all_matches.where(first_user_status: 'Yes').count
    @second_user_yes_count = @all_matches.where(second_user_status: 'Yes').count
    @first_user_no_count = @all_matches.where(first_user_status: 'No').count
    @second_user_no_count = @all_matches.where(second_user_status: 'No').count
    @reference_count = Reference.all.count
  end
end
