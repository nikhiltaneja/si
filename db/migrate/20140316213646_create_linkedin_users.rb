class CreateLinkedinUsers < ActiveRecord::Migration
  def change
    create_table :linkedin_users do |t|
      t.string :uid

      t.timestamps
    end
  end
end
