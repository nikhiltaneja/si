class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :matches?, only: [:index, :show]
  before_action :approved?, only: [:index, :show]

  def index
    @matches = current_user.matches
  end

  def show
    if params[:id]
      @match = Match.find(params[:id])
    else
      @match = current_user.current_match
    end

    if @match.first_user == current_user
      @user = @match.second_user
    else
      @user = @match.first_user
    end

    @shared = @user.shared_connections(@match.id).count

  end

  def create
    if params[:user_1].to_i < params[:user_2].to_i
      Match.create!(first_user_id: params[:user_1], second_user_id: params[:user_2])
    else
      Match.create!(first_user_id: params[:user_2], second_user_id: params[:user_1])
    end

    PotentialmatchWorker.perform_async(params[:user_1], params[:user_2])

    redirect_to admins_path, notice: "Match successfully created!"
  end

  def update
    @match = Match.find(params[:id])
    to_update = current_user.id == @match.first_user_id ? :first_user_status : :second_user_status
    @match.update(to_update => params[:decision])
    other_user_id = current_user.id == @match.first_user_id ? @match.second_user_id : @match.first_user_id
    ScoreWorker.perform_async(other_user_id)

    if @match.match_status
      # UserMailer.match_confirmation(@match.first_user, @match.second_user).deliver
      MatchmadeWorker.perform_async(@match.first_user.id, @match.second_user.id)
    end

    redirect_to root_path, notice: "Thanks for submitting your response!"
  end
end
