class ScoreWorker
  include Sidekiq::Worker

  def perform(user1_id, user2_id)
    user1 = User.find(user1_id)
    user2 = User.find(user2_id)
    #call calculate_score for preferably one user, but maybe both
   
  end
end