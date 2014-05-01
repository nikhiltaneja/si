class ActiveWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

   UserMailer.active_email(user).deliver
  end
end