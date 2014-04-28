class CreateLocationInterests < ActiveRecord::Migration
  def change
    create_table :location_interests do |t|
      t.references :user, index: true
      t.references :location, index: true

      t.timestamps
    end
  end
end
