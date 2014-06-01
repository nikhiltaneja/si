class AddTotalConnectionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :total_connections, :integer
  end
end
