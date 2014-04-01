class UserMailer < ActionMailer::Base
  default from: "matches@swiftintro.com"

  def approved_confirmation(user)
    @user = user

    mail to: [@user.email], subject: 'Welcome to SwiftIntro!'
  end

  def rejected_confirmation(user)
    @user = user

    mail to: [@user.email], subject: 'SwiftIntro Update'
  end

  def potential_match(user)
    @user = user

    mail to: [@user.email], subject: 'Potential Match!'
  end

  def match_confirmation(first_user, second_user)
    @first_user = first_user
    @second_user = second_user

    mail to: [@first_user.email, @second_user.email], subject: 'Successful Match!'
  end
end
