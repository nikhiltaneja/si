class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, unless: :admin?

  def show
    id = params[:id]
  	@user = User.find(id)
  end
end
