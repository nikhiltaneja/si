class AddBadgeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :badge, :boolean, default: false
  end
end
