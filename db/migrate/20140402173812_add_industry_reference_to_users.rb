class AddIndustryReferenceToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :industry, index: true
  end
end
