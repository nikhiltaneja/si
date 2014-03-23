class AddIndexToMatches < ActiveRecord::Migration
  def change
    add_index :matches, :first_user_id
    add_index :matches, :second_user_id
  end
end
