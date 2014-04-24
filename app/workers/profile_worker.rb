class ProfileWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    if user.topic_interests.empty?
      TopicInterest.create!(user_id: user.id, topic_id: 1)
      TopicInterest.create!(user_id: user.id, topic_id: 2)
      TopicInterest.create!(user_id: user.id, topic_id: 3)
    end
    
    User.get_educations(user)
    User.get_jobs(user)
  end
end
