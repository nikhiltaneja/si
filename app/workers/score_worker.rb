class ScoreWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    user.calculate_score
    
  end
end