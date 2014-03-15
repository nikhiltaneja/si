OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'],
  :scope => 'r_fullprofile r_emailaddress r_network',
  :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "educations", "three-current-positions", "three-past-positions", "interests", "skills", "summary", "volunteer", "following", "connections"]
end
