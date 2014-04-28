class AddPremiumEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :premium_email, :boolean, default: false
  end
end
