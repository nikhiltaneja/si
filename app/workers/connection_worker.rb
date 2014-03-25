class ConnectionWorker
  include Sidekiq::Worker

  def perform(connections, user_id)
    add_connections(connections, user_id)
  end
end