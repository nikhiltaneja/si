class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, only: [:show], unless: :admin?

  def show
    if params[:id]
  	  @user = User.find(params[:id])
    elsif current_user
      @user = current_user
    end

  end

  def update
    user = User.find(params[:id])

    if params[:approved]
      user.approved = params[:approved]

      DecisionWorker.perform_async(user.id, params[:approved])

      user.save
      redirect_to :back
    end

    if params[:user]
      user.industry_id = params[:user][:industry_id]
      user.summary = params[:user][:summary]

      initial_interests = IndustryInterest.where(user_id: user.id)

      updated_interests = params[:industry_interests].collect do |industry_interest_id|
        IndustryInterest.find_or_create_by(user_id: user.id, industry_id: industry_interest_id)
      end

      expired_interests = initial_interests - updated_interests

      expired_interests.each do |expired_interest|
        expired_interest.delete
      end

      user.save

      if user.approved == "Yes"
        redirect_to user_path(user), notice: 'Profile updated!'
      else        
        redirect_to user_path(user), notice: 'Thank you for expressing interest in SwiftIntro!  We will email you soon with more information about our beta program.'
      end
    end
    
    # if params[:user][:industry_interests]
    #   IndustryInterest.find_or_create_by(:user_id => params[:user_id], :industry_id => params[:user][:industry_interests])
    # end
  end

  def edit
    @user = User.find(params[:id])
  end
end
