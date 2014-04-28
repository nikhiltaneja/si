class AddNumberMatchesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_of_matches, :integer, default: 1
  end
end
