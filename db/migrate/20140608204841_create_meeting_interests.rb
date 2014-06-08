class CreateMeetingInterests < ActiveRecord::Migration
  def change
    create_table :meeting_interests do |t|
      t.references :user, index: true
      t.references :meeting, index: true

      t.timestamps
    end
  end
end
