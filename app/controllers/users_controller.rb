class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, only: [:show], unless: :admin?
  before_action :approved?, only: [:show], unless: :admin?

  def show
  	@user = User.find(params[:id])
  end

  def request_received
  end

  def update
    user = User.find(params[:id])

    if params[:approved]
      user.approved = params[:approved]

      if user.approved == "Yes"
        UserMailer.approved_confirmation(user).deliver
      end

      if user.approved == "No"
        UserMailer.rejected_confirmation(user).deliver
      end
    end

    user.save

    redirect_to :back
  end
end
