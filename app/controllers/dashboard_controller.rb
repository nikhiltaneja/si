class DashboardController < ApplicationController
  before_action :logged_in?, only: [:index]

  def index
    cookies['ref-id'] = params[:ref] if params[:ref]
  end

  def contact
  end

  def faq
  end

  def privacy
  end
  
  def terms
  end
end
