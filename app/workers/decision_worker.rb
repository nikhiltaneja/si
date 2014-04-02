class DecisionWorker
  include Sidekiq::Worker

  def perform(user_id, decision)
    user = User.find(user_id)
    
   if decision == "Yes"
     UserMailer.approved_confirmation(user).deliver
   end

   if decision == "No"
     UserMailer.rejected_confirmation(user).deliver
   end
  end
end
