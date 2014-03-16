class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :company, index: true
      t.references :position, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
