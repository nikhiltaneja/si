class AddOtherUserIdRef < ActiveRecord::Migration
  def change
    add_column :references, :other_user_id, :integer
  end
end
