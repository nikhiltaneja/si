class EmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform()
  jay = User.first
  jay.name = "1"
  jay.save
  end
end
