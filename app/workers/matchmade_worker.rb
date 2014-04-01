class MatchmadeWorker
  include Sidekiq::Worker

  def perform(user1_id, user2_id)
    user1 = User.find(user1_id)
    user2 = User.find(user2_id)
    UserMailer.match_confirmation(user1, user2).deliver
  end
end
