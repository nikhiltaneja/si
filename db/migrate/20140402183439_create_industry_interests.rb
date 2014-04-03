class CreateIndustryInterests < ActiveRecord::Migration
  def change
    create_table :industry_interests do |t|
      t.references :user, index: true
      t.references :industry, index: true

      t.timestamps
    end
  end
end
