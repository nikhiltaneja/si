class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, only: [:show, :edit, :invite], unless: :admin?

  def show
    if params[:id]
  	  @user = User.find(params[:id])
    elsif current_user
      @user = current_user
    end

  end

  def update
    @user = User.find(params[:id])

    if params[:approved]
      @user.approved = params[:approved]

      DecisionWorker.perform_async(@user.id, params[:approved])

      @user.save
      redirect_to :back
    end

    if params[:user]
      @user.industry_id = params[:user][:industry_id]
      @user.summary = params[:user][:summary]
      @user.seeking = params[:user][:seeking]

      @user.industry_interests.where.not(industry_id: params[:industry_interests]).delete_all
      @user.topic_interests.where.not(topic_id: params[:topic_interests]).delete_all


      if params[:industry_interests]
        params[:industry_interests].each do |industry_interest_id|
          IndustryInterest.find_or_create_by(user_id: @user.id, industry_id: industry_interest_id)
        end
      end

      if params[:topic_interests]
        params[:topic_interests].each do |topic_interest_id|
          TopicInterest.find_or_create_by(user_id: @user.id, topic_id: topic_interest_id)
        end
      end

      if @user.save
        if @user.approved == "Yes"
          redirect_to user_path(@user), notice: 'Profile updated!'
        else        
          redirect_to user_path(@user), notice: 'Thank you for expressing interest in SwiftIntro!  We will email you soon with more information about our beta program.'
        end
      else
        render action: 'edit'
      end
    end

    if cookies.signed['ref-id'] && Reference.where.not(other_user_id: current_user.id)
      cookie_user = User.where(uid: cookies.signed['ref-id'])
      if cookie_user.length == 1
        Reference.create(user_id: cookie_user[0].id, other_user_id: current_user.id)
      end
    end

  end

  def edit
    @user = User.find(params[:id])
  end

  def invite
    @user = User.find(params[:id])
  end
end
