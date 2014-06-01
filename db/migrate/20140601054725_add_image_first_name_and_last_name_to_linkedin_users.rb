class AddImageFirstNameAndLastNameToLinkedinUsers < ActiveRecord::Migration
  def change
    add_column :linkedin_users, :image, :string
    add_column :linkedin_users, :first_name, :string
    add_column :linkedin_users, :last_name, :string
  end
end
