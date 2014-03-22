class MatchesController < ApplicationController
  before_action :current_user?
  before_action :matches?

  def index
    @matches = current_user.matches
  end

  def show
    if params[:id]
      id = params[:id]
      @match = Match.find(id)
    else
      @match = current_user.current_match
    end

    if @match.first_user == current_user
      @user = @match.second_user
    else
      @user = @match.first_user
    end
  end

  def update
    @match = Match.find(params[:id])
    to_update = current_user.id == @match.first_user_id ? :first_user_status : :second_user_status
    @match.update(to_update => params[:decision])

    if @match.match_status
      UserMailer.match_confirmation(@match.first_user, @match.second_user).deliver
    end

    redirect_to root_path, notice: "Thanks for submitting your response!"
  end
end
