class ReaddApprovedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approved, :string, default: "pending"
  end
end
