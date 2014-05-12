class UserMailer < ActionMailer::Base
  default from: '"SwiftIntro" <info@swiftintro.com>'

  def initial_signup(user)
    @user = user

    mail to: [@user.email], subject: 'Thanks for signing up for SwiftIntro'
  end

  def approved_confirmation(user)
    @user = user

    mail to: [@user.email], subject: 'Welcome to SwiftIntro!'
  end

  def rejected_confirmation(user)
    @user = user

    mail to: [@user.email], subject: 'SwiftIntro Update'
  end

  def potential_match(first_user, second_user)
    @first_user = first_user
    @second_user = second_user
    @shared_connections_count = first_user.shared_connections(second_user.id).count

    mail to: [@first_user.email], subject: "Suggested Intro: Meet #{@second_user.first_name}, #{@second_user.headline}"
  end

  def match_confirmation(first_user, second_user)
    @first_user = first_user
    @second_user = second_user
    @shared_connections_count = first_user.shared_connections(second_user.id).count
    if !@first_user.deleted || !@second_user.deleted
      mail to: [@first_user.email, @second_user.email], subject: "Intro: #{@first_user.first_name} <> #{@second_user.first_name}"
    end
  end

  def premium_notification(user)
    @user = user

    mail to: [@user.email], subject: "#{@user.first_name}: Congratulations on Achieving Premium Status"
  end

  def active_notification(user)
    @user = user
    mail to: [@user.email], subject: "#{@user.first_name}: Your account at SwiftIntro is approaching inactive status"
  end
end
