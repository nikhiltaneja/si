class RemoveUserStatusesFromMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :first_user_status
    remove_column :matches, :second_user_status
  end
end
