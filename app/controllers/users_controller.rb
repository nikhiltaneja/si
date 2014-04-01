class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, unless: :admin?

  def show
  	@user = User.find(params[:id])
  end

  def request_received
  end

  def update
    @user = User.find(params[:id])

    if params[:approved]
      @user.approved = params[:approved]
    end

    @user.save
    redirect_to :back
  end
end
