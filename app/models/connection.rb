class Connection < ActiveRecord::Base
  belongs_to :linkedin_user
  belongs_to :user
end
