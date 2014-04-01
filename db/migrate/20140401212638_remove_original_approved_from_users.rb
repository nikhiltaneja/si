class RemoveOriginalApprovedFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :approved
  end
end
