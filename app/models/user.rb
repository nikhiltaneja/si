class User < ActiveRecord::Base
  has_one :location
  has_many :educations
  has_many :jobs

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

    if user_educations
      add_educations(user_educations, user.id)
    end

    if current_jobs
      add_current_jobs(current_jobs, user.id)
    end

    if past_jobs
      add_past_jobs(past_jobs, user.id)
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
end
