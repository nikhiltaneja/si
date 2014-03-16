class LinkedinUser < ActiveRecord::Base
  has_many :connections
end
