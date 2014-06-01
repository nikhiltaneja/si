class RemoveImageAndFirstNameFromConnections < ActiveRecord::Migration
  def change
    remove_column :connections, :image
    remove_column :connections, :first_name
  end
end
