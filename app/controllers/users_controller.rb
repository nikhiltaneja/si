class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?

  def index
    id = params[:id]
    @user = User.find(id)
    # user_match_id = User.get_match(@user)
    # @user_match = User.find(user_match_id)
  end

  def show
    id = params[:id]
  	@user = User.find(id)
  end

  def edit
  	id = params[:id]
    @user = User.find(id)
  end

  def update
  end
end
