class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.references :linkedin_user, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
