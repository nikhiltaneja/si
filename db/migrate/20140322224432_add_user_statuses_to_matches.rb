class AddUserStatusesToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :first_user_status, :string, default: 'pending'
    add_column :matches, :second_user_status, :string, default: 'pending'
  end
end
