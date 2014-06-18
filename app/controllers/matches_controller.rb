class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :matches?, only: [:index, :show]
  before_action :approved?, only: [:index, :show]
  before_action :correct_match?, only: [:show]

  def index
    @matches = current_user.matches.where(match_status: false).select do |match|
      if match.first_user_id == current_user.id
        match.first_user_status == "pending"
      elsif match.second_user_id == current_user.id
        match.second_user_status == "pending"
      end
    end
  end

  def show
    @message = Message.new
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

    @shared_connections = current_user.shared_connections(@user.id)    
  end

  def create
    if params[:user_1].to_i < params[:user_2].to_i
      Match.create!(first_user_id: params[:user_1], second_user_id: params[:user_2])
    else
      Match.create!(first_user_id: params[:user_2], second_user_id: params[:user_1])
    end

    redirect_to admins_path, notice: "Intro successfully created!"
  end

  def update
    @match = Match.find(params[:id])
    to_update = current_user.id == @match.first_user_id ? :first_user_status : :second_user_status
    @match.update(to_update => params[:decision])
    other_user_id = current_user.id == @match.first_user_id ? @match.second_user_id : @match.first_user_id
    ScoreWorker.perform_async(other_user_id)

    if @match.match_status
      MatchmadeWorker.perform_async(current_user.id, other_user_id)
    end

    user_decision = current_user.id == @match.first_user_id ? @match.first_user_status : @match.second_user_status

    if current_user.active == false
      current_user.active = true
      current_user.save!
    end

    if user_decision == "Yes"
      current_user.matches.where(match_status: false).each do |match|
        if match.first_user_id == current_user.id && match.first_user_status == "pending"
          return redirect_to user_matches_path(current_user), notice: "Thanks, we will email you soon if an introduction is made. Please respond to these pending intros in the meantime."
        elsif match.second_user_id == current_user.id && match.second_user_status == "pending"
          return redirect_to user_matches_path(current_user), notice: "Thanks, we will email you soon if an introduction is made. Please respond to these pending intros in the meantime."
        end
      end

      redirect_to root_path, notice: "Thanks for submitting your response! We will email you soon if an introduction is made."

    elsif user_decision == "No"
      current_user.matches.where(match_status: false).each do |match|
        if match.first_user_id == current_user.id && match.first_user_status == "pending"
          return redirect_to user_matches_path(current_user), notice: "Thanks for submitting your response. Please respond to these pending intros in the meantime."
        elsif match.second_user_id == current_user.id && match.second_user_status == "pending"
          return redirect_to user_matches_path(current_user), notice: "Thanks for submitting your response. Please respond to these pending intros in the meantime."
        end
      end

      redirect_to root_path, notice: "Thanks for submitting your response."
    else
      redirect_to root_path
    end
  end

  def prior_matches
    @matches = current_user.matches.where(match_status: true)
  end

  def send_potential_match_email
    @match = Match.find(params[:id])
    user1 = @match.first_user
    user2 = @match.second_user

    @match.email_status = true
    
    PotentialmatchWorker.perform_async(user1.id, user2.id)
    
    @match.save!

    if user1.five_matches_pending
      ActiveWorker.perform_async(user1.id)
      user1.active = false
      user1.save!
    end

    if user2.five_matches_pending
      ActiveWorker.perform_async(user2.id)
      user2.active = false
      user2.save!
    end

    redirect_to admins_queue_path, notice: 'Emails sent!'
  end
end
