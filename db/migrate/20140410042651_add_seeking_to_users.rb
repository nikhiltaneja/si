class AddSeekingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seeking, :text
  end
end
