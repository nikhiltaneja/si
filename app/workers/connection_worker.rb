class ConnectionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    User.get_connections(user)
  end
end