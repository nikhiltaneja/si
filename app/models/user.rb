class User < ActiveRecord::Base
  has_one :location

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.headline = auth["info"]["headline"]
      user.summary = auth["extra"]["raw_info"]["summary"]
      user.industry = auth["info"]["industry"]
      user.location = Location.find_or_create_by(area: auth["info"]["location"])
      user.image = auth["info"]["image"]
      user.public_profile = auth["info"]["urls"]["public_profile"]
    end
  end
end
