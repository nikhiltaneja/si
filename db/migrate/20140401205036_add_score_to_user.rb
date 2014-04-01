class AddScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :score, :float, default: 0.0
  end
end
