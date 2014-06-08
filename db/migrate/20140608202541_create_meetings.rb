class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name

      t.timestamps
    end
  end
end
