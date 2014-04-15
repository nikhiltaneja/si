class AddIndexOtherRef < ActiveRecord::Migration
  def change
     add_index :references, :other_user_id
  end
end
