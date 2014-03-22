class Match < ActiveRecord::Base
  belongs_to :first_user, class_name: "User", foreign_key: :first_user_id
  belongs_to :second_user, class_name: "User", foreign_key: :second_user_id

  before_save :set_match_status

  def set_match_status
    if first_user_status == "Yes" && second_user_status == "Yes"
      self.match_status = true
    end
  end
end
