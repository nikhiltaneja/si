class MatchesController < ApplicationController
  def show
    @match = Match.find(params[:id])

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

    redirect_to root_path, notice: "Thanks for submitting your response!"
  end
end
