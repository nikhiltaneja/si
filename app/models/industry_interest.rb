class IndustryInterest < ActiveRecord::Base
  belongs_to :user
  belongs_to :industry
end
