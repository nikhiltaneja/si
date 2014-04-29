class AddImageToConnection < ActiveRecord::Migration
  def change
    add_column :connections, :image, :string
    add_column :connections, :first_name, :string
  end
end
