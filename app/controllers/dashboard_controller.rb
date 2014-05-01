class DashboardController < ApplicationController
  before_action :logged_in?, only: [:index]

  def index
    cookies.signed['ref-id'] = params[:ref]
  end

  def contact
  end

  def faq
  end

  def terms
  end
end
