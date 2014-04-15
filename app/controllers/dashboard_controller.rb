class DashboardController < ApplicationController
  before_action :logged_in?

  def index
    cookies.signed['ref-id'] = params[:ref]
  end
end
