class ProfileWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    
    User.get_educations(user)
    User.get_jobs(user)
  end
end