class RemoveOtherUserReference < ActiveRecord::Migration
  def change
    remove_column :references, :other_user_id
  end
end
