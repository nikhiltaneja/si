class AddReferenceToLinkedinUserIdInUsers < ActiveRecord::Migration
  def change
    add_reference :users, :linkedin_user, index: true
  end
end
