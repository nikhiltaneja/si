class CreateTopicInterests < ActiveRecord::Migration
  def change
    create_table :topic_interests do |t|
      t.references :user, index: true
      t.references :topic, index: true

      t.timestamps
    end
  end
end
