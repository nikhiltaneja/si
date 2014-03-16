class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :area
      t.references :user, index: true

      t.timestamps
    end
  end
end
