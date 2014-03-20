class UserMailer < ActionMailer::Base
  default from: "matches@swiftintro.com"

  def match_confirmation(first_user, second_user)
    @first_user = first_user
    @second_user = second_user

    mail to: [@first_user.email, @second_user.email], subject: 'Successful Match!'
  end
end
