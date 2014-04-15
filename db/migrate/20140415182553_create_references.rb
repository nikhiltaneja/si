class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.references :user, index: true
      t.string :other_user_id

      t.timestamps
    end
  end
end
