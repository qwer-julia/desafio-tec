class SessionsController < ApplicationController
  layout "guest"
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to login_path, alert: "Tente de novo mais tarde." }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    if user.nil?
      redirect_to login_path, alert: "E-mail ou senha inválidos."
    elsif !user.confirmed?
      redirect_to login_path, alert: "Confirme seu e-mail antes de entrar. Verifique sua caixa de entrada."
    else
      start_new_session_for user
      redirect_to after_authentication_url
    end
  end

  def destroy
    terminate_session
    redirect_to login_path, status: :see_other
  end
end
