class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.references :school, index: true
      t.references :subject, index: true
      t.references :degree, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
