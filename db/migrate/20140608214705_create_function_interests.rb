class CreateFunctionInterests < ActiveRecord::Migration
  def change
    create_table :function_interests do |t|
      t.references :user, index: true
      t.references :function, index: true

      t.timestamps
    end
  end
end
