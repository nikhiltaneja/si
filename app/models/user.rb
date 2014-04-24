class User < ActiveRecord::Base
  belongs_to :location
  belongs_to :industry
  has_many :educations
  has_many :jobs
  has_many :connections
  has_many :industry_interests
  has_many :references

  has_many :first_users, class_name: "Match", foreign_key: :first_user_id
  has_many :second_users, class_name: "Match", foreign_key: :second_user_id

  validate :seeking_complete?, on: :update


  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first_or_initialize.tap do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.headline = auth["info"]["headline"]
      user.location = Location.find_or_create_by(area: auth["info"]["location"])
      user.public_profile = auth["info"]["urls"]["public_profile"]
      user.token = auth["extra"]["access_token"].token
      user.secret = auth["extra"]["access_token"].secret
      user.save! 

      if !user.linkedin_user_id
        user.linkedin_user_id = LinkedinUser.find_or_create_by(uid: user.uid).id
        user.save!
      end

      ProfileWorker.perform_async(user.id)
      ConnectionWorker.perform_async(user.id)

      user.image = User.get_profile_picture(user)

      user.save!

      if user.signup_email == false
        InitialSignupWorker.perform_async(user.id)
        user.signup_email = true
        user.save!
      end

      user
    end
  end


  def matches
    Match.where("first_user_id = ? OR second_user_id = ?", self.id, self.id).order(:created_at)
  end

  def current_match
    matches.last
  end

  def eligible_for_new_match?
    if self.current_match
      (Time.now - self.current_match.created_at) > 432000 #five days
    else
      true
    end
  end

  def find_potential_matches
    users_same_location = remove_different_location(remove_unapproved_users)
    users_no_previous_matches = remove_previous_matches(users_same_location)
    users_no_first_degree_connections = remove_first_degree_connections(users_no_previous_matches)
    remove_oneself(users_no_first_degree_connections)
  end

  def remove_unapproved_users
    User.where(approved: "Yes")
  end

  def remove_different_location(users)
    users.where(location_id: self.location.id)
  end

  def remove_previous_matches(users)
    # filtered_users = []
    # users.each do |user|
    #   if self.id < user.id
    #     unless Match.find_by(first_user_id: self.id, second_user_id: user.id)
    #       filtered_users << user
    #     end
    #   else
    #     unless Match.find_by(first_user_id: user.id, second_user_id: self.id)
    #       filtered_users << user
    #     end
    #   end
    # end
    # filtered_users

    #simon's code
    matched_user_ids1 = Match.where(first_user_id: self.id).pluck(:second_user_id)
    matched_user_ids2 = Match.where(second_user_id: self.id).pluck(:first_user_id)
    
    matched_user_ids = matched_user_ids1 + matched_user_ids2
    users.where.not(:id => matched_user_ids)
  end

  def remove_first_degree_connections(users)
    # self.connections.pluck(:linkedin_user_id) & users.pluck(:linkedin_user_id)

    users.reject do |user|
      if user.eligible_for_new_match?
        self.connections.pluck(:linkedin_user_id).include?(user.linkedin_user_id)
      else
        true
      end
    end
  end

  def remove_oneself(users)
    users.delete(self)
    users
  end

  def shared_connections(user_id) #returns linkedin_user_id array
    first_user_connections = Connection.where(user_id: self.id).pluck(:linkedin_user_id)
    second_user_connections = Connection.where(user_id: user_id).pluck(:linkedin_user_id)

    mutual_connections = first_user_connections & second_user_connections
  end

  def calculate_score  #updates a user's score 
    meetups_requested = []
    #should do an if statement to see if matches.length > 10 to exclude new people
    for m in self.matches
      if self.id == m.first_user_id && m.second_user_status == "Yes"
        meetups_requested << m.second_user_id
      elsif self.id == m.second_user_id && m.first_user_status == "Yes"
        meetups_requested << m.first_user_id
      end
    end
    # doesn't account for people who don't respond
    self.score = (meetups_requested.length / self.matches.length)*100
    self.save
  end

  def self.get_connections(user)
    client = LinkedIn::Client.new(ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'])
    client.authorize_from_access(user.token, user.secret)
    if client.connections["total"] != 0
      client.connections["all"].each do |connection|
        linkedin_user = LinkedinUser.find_or_create_by(uid: connection["id"])
        Connection.find_or_create_by(user_id: user.id, linkedin_user_id: linkedin_user.id)
      end
    end
  end

  def self.get_profile_picture(user)
    client = LinkedIn::Client.new(ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'])
    client.authorize_from_access(user.token, user.secret)
    if client.picture_urls['total'] != 0
      return client.picture_urls["all"][0]
    else
      return 'http://food52.com/assets/avatars/default-medium.png'
    end
  end

  def self.get_jobs(user)
    client = LinkedIn::Client.new(ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'])
    client.authorize_from_access(user.token, user.secret)
    jobs = client.profile(:fields => %w(positions))
    if jobs['positions']['total'] > 0
      jobs['positions']['all'].each do |job|
        company = Company.find_or_create_by(name: job['company']['name'])
        position = Position.find_or_create_by(name: job['title'])
        Job.find_or_create_by(user_id: user.id, company_id: company.id, position_id: position.id)
      end
    end
  end

  def self.get_educations(user)
    client = LinkedIn::Client.new(ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'])
    client.authorize_from_access(user.token, user.secret)
    educations = client.profile(:fields => %w(educations))

    if educations['educations']['total'] > 0
      educations['educations']['all'].each do |education|
        school = School.find_or_create_by(name: education["school_name"])
        subject = Subject.find_or_create_by(name: education["field_of_study"])
        degree = Degree.find_or_create_by(name: education['degree'])
        # if education["endDate"] && education["endDate"]["year"]
        #   grad_year = education["endDate"]["year"].to_s
        #   Education.find_or_create_by(user_id: user_id, school_id: school.id, subject_id: subject.id, degree_id: degree.id).update(year: grad_year)
        # else
          Education.find_or_create_by(user_id: user.id, school_id: school.id, subject_id: subject.id, degree_id: degree.id)
        # end
      end
    end
  end

  private
  
  def seeking_complete?
    if self.seeking.nil?
      return true
    elsif self.seeking.empty?
      self.errors[:base] << "What You're Looking For Cannot Be Blank"
    else
      return true
    end
  end
end
