class MailchimpWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    user.add_mailchimp
  end
end
