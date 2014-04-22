class InitialSignupWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    UserMailer.initial_signup(user).deliver
  end
end
