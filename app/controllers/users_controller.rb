class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, only: [:show], unless: :admin?
  before_action :approved?, only: [:show], unless: :admin?

  def show
  	@user = User.find(params[:id])
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
