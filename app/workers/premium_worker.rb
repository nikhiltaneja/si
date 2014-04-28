class PremiumWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    
    UserMailer.premium_notification(user).deliver
  end
end
