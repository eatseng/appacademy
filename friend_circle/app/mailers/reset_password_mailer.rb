class ResetPasswordMailer < ActionMailer::Base
  default from: "from@example.com"

  def reset_password_email(user)
    @user = user

    @email_token = user.email_token

    @url = Addressable::URI.new(
      :scheme => "http",
      :host => "localhost",
      :port => "3000",
      :path => "users/set_new_password",
      :query_values => {:email_token => "#{@email_token}"}
    ).to_s

    mail(to: user.email, subject: "Reset Password Link")

  end

end
