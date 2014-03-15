class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :email, :string
    add_column :users, :headline, :text
    add_column :users, :summary, :text
    add_column :users, :industry, :string
    add_column :users, :location, :string
    add_column :users, :image, :string
    add_column :users, :public_profile, :string
  end
end
