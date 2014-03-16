class RemoveTypeFromDegrees < ActiveRecord::Migration
  def change
    remove_column :degrees, :type
    add_column :degrees, :name, :string
  end
end
