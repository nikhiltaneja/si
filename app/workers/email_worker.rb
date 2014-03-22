class EmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly}

  def perform()
   
  end
end
