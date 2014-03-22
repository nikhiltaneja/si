class User < ActiveRecord::Base
  belongs_to :location
  has_many :educations
  has_many :jobs
  has_many :connections

  has_many :first_users, class_name: "Match", foreign_key: :first_user_id
  has_many :second_users, class_name: "Match", foreign_key: :second_user_id

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    user = create! do |user|
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

    user_educations = auth["extra"]["raw_info"]["educations"]["values"]
    current_jobs = auth["extra"]["raw_info"]["threeCurrentPositions"]["values"]
    past_jobs = auth["extra"]["raw_info"]["threePastPositions"]["values"]

    user_connections = auth["extra"]["raw_info"]["connections"]["values"]

    if user_educations
      add_educations(user_educations, user.id)
    end

    if current_jobs
      add_current_jobs(current_jobs, user.id)
    end

    if past_jobs
      add_past_jobs(past_jobs, user.id)
    end

    if user_connections
      add_connections(user_connections, user.id)
    end

    user
  end

  def self.add_educations(user_educations, user_id)
    user_educations.each do |education|
      school = School.find_or_create_by(name: education.schoolName)
      subject = Subject.find_or_create_by(name: education.fieldOfStudy)
      degree = Degree.find_or_create_by(name: education.degree)
      Education.create!(user_id: user_id, school_id: school.id, subject_id: subject.id, degree_id: degree.id)
    end
  end

  def self.add_current_jobs(current_jobs, user_id)
    current_jobs.each do |job|
      company = Company.find_or_create_by(name: job["company"].name)
      position = Position.find_or_create_by(name: job["title"])
      Job.create(user_id: user_id, company_id: company.id, position_id: position.id)
    end
  end

  def self.add_past_jobs(past_jobs, user_id)
    past_jobs.each do |job|
      company = Company.find_or_create_by(name: job["company"].name)
      position = Position.find_or_create_by(name: job["title"])
      Job.create(user_id: user_id, company_id: company.id, position_id: position.id)
    end
  end

  def self.add_connections(user_connections, user_id)
    user_connections.each do |connection|
      linkedin_user = LinkedinUser.find_or_create_by(uid: connection["id"])
      Connection.create(user_id: user_id, linkedin_user_id: linkedin_user.id)
    end
  end
 
#one method to return an array of location matches
#put 2 users which outputs an array of shared connections 
#method which removes first degree connection
# method which removes inactive users
# method which strips people tehy already matched with

  def location_matches(user)
    same_location = User.where(location_id: user.location.id)
    same_user_ids = []
    same_location.each do |u|
      same_user_ids << u.id
    end
    same_user_ids
  end

  def shared_connections(user1, user2)
    shared_connections = []
    s1 = Connection.where(user_id: user1.id)
    s2 = Connection.where(user_id: user2.id)
    s1.each do |c|
      
    end
  end

#  def self.create_location_matches(primary_user)
#   loc_id = primary_user.location.id
#   same_loc = User.where(location_id: loc_id)
#   same_loc.each do |user|
#     if Match.where(first_user_id: user.id, second_user_id: primary_user.id)  == []
#       if primary_user.id > user.id
#         Match.create(first_user_id: user.id, second_user_id: primary_user.id)
#       end
#     end
#     if Match.where(first_user_id: primary_user.id, second_user_id: user.id)  == []
#       if primary_user.id < user.id
#         Match.create(first_user_id: primary_user.id, second_user_id: user.id)
#       end
#     end
#   end
#  end

#  def self.get_match(user_id)
#     matches = Match.where(first_user_id: user_id)
#     matches2 = Match.where(second_user_id: user_id)
#     total_matches = matches + matches2
#     match = total_matches.sample
#     if match.first_user_id == user_id
#       return second_user_id
#     else
#       return first_user_id
#     end
#  end
end
