class Industry < ActiveRecord::Base
  has_many :users
  has_many :industry_interests
end
