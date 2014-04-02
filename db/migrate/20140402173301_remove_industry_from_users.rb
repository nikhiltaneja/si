class RemoveIndustryFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :industry
  end
end
