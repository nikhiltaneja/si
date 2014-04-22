class UserMailer < ActionMailer::Base
  default from: '"SwiftIntro" <matches@swiftintro.com>'

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

    mail to: [@first_user.email], subject: "Potential Match: Meet #{@second_user.first_name}"
  end

  def match_confirmation(first_user, second_user)
    @first_user = first_user
    @second_user = second_user
    @shared_connections_count = first_user.shared_connections(second_user.id).count

    mail to: [@first_user.email, @second_user.email], subject: "Intro: #{@first_user.first_name} <> #{@second_user.first_name}"
  end
end
