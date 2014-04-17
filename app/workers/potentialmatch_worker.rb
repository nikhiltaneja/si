class PotentialmatchWorker
  include Sidekiq::Worker

  def perform(user1_id, user2_id)
    first_user = User.find(user1_id)
    second_user = User.find(user2_id)

    UserMailer.potential_match(first_user, second_user).deliver
    UserMailer.potential_match(second_user, first_user).deliver
  end
end
