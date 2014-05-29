class User < ActiveRecord::Base
  belongs_to :location
  belongs_to :industry
  has_many :educations
  has_many :jobs
  has_many :connections
  has_many :industry_interests
  has_many :topic_interests
  has_many :location_interests
  has_many :references
  has_many :skill_interests

  has_many :first_users, class_name: "Match", foreign_key: :first_user_id
  has_many :second_users, class_name: "Match", foreign_key: :second_user_id

  # validate :topic_interests_complete?, on: :update

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

      if !user.premium_email && user.premium?
        PremiumWorker.perform_async(user.id)
        user.premium_email = true
        user.badge = true
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

      if user.deleted == true
        user.deleted = false
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
    if self.number_of_matches == 2
      if self.current_match
        (Time.now - self.current_match.created_at) > 172800 #two days
      else
        true
      end
    else
      if self.current_match
        (Time.now - self.current_match.created_at) > 345600 #four days
      else
        true
      end
    end
  end

  def premium?
    self.references.count >= 5
  end

  def find_potential_matches
    users_no_previous_matches = remove_previous_matches(remove_unapproved_users_and_different_location)
    users_no_first_degree_connections = remove_first_degree_connections(users_no_previous_matches)
    remove_oneself(users_no_first_degree_connections)
  end

  def remove_unapproved_users_and_different_location
    User.where(approved: "Yes").where(deleted: false).where(active: true).where(location_id: self.location.id)
  end

  def remove_previous_matches(users)
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

   def shared_connections_pics(user_id) #returns connection images and first names array
    first_user_connections = Connection.where(user_id: self.id).where.not(image: nil).pluck(:first_name, :image)
    second_user_connections = Connection.where(user_id: user_id).where.not(image: nil).pluck(:first_name, :image)

    mutual_connections = first_user_connections & second_user_connections
    mutual_connections.sample(5)
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
    self.score = ((meetups_requested.length.to_f / self.matches.length.to_f)*100).round(2)
    self.save
  end

  def self.get_connections(user)
    client = LinkedIn::Client.new(ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'])
    client.authorize_from_access(user.token, user.secret)
    if client.connections["total"] != 0
      client.connections["all"].each do |connection|
        linkedin_user = LinkedinUser.find_or_create_by(uid: connection["id"])
        c = Connection.find_or_create_by(user_id: user.id, linkedin_user_id: linkedin_user.id)
        c.image = connection['picture_url']
        c.first_name = connection['first_name']
        c.save!
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

  def self.get_skills(user)
    client = LinkedIn::Client.new(ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'])
    client.authorize_from_access(user.token, user.secret)
    skills = client.profile(:fields => %w(skills))

    if skills['skills'] && skills['skills']['total'] > 0
      skills['skills']['all'].each do |skill|
        my_skill = Skill.find_or_create_by(name: skill["skill"]["name"])
        SkillInterest.find_or_create_by(skill_id: my_skill.id , user_id: user.id)
      end
    end
  end

  def compare_skills_count(user)
    skills1 = self.skill_interests.pluck(:skill_id)
    skills2 = user.skill_interests.pluck(:skill_id)

    shared_skills = skills1 & skills2
    shared_skills.count
  end

  def compare_industry_interests_count(user)
    industry_interests1 = self.industry_interests.pluck(:industry_id)
    industry_interests2 = user.industry_interests.pluck(:industry_id)

    shared_industry_interests = industry_interests1 & industry_interests2
    shared_industry_interests.count
  end

  def five_matches_pending
    matches = self.matches
    count = 0
    5.times do |i|
      if matches[-(i+1)] == nil
        return false
      end
      if matches[-(i+1)].first_user_id == self.id && matches[-(i+1)].first_user_status == "pending" 
        count = count + 1;
      elsif matches[-(i+1)].second_user_id == self.id && matches[-(i+1)].second_user_status == "pending"
        count = count + 1; 
      end
    end
    if count == 5
      return true
    else 
      return false
    end
  end

  def add_mailchimp
    gb = Gibbon::API.new(ENV['MAILCHIMP_KEY'])
    gb.lists.subscribe({:id => '54f2f26d18', :email => {:email => self.email}, :merge_vars => {:FNAME => self.first_name, :LNAME => self.last_name}, :double_optin => false})
  end


  private
  
  # def topic_interests_complete?
  #   if self.topic_interests.empty?
  #     self.errors[:base] << '"What Are You Interested In?" Cannot Be Blank'
  #   else
  #     return true
  #   end
  # end
end
