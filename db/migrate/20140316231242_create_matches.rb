class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :first_user_id
      t.integer :second_user_id
      t.boolean :first_user_status, default: false
      t.boolean :second_user_status, default: false
      t.boolean :match_status, default: false
      t.boolean :email_status, default: false

      t.timestamps
    end
  end
end
