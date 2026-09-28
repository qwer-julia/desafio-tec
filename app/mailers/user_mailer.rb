class UserMailer < ApplicationMailer
  def confirmation(user)
    @user = user
    @token = user.generate_token_for(:email_confirmation)
    mail subject: "Confirme seu e-mail", to: user.email_address
  end
end
