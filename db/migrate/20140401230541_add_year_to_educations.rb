class AddYearToEducations < ActiveRecord::Migration
  def change
    add_column :educations, :year, :string
  end
end
