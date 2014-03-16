class Education < ActiveRecord::Base
  belongs_to :school
  belongs_to :subject
  belongs_to :degree
  belongs_to :user
end
