class ConfirmationsController < ApplicationController
  layout "guest"
  allow_unauthenticated_access

  def show
    result = Users::ConfirmEmail.new(token: params[:token]).call

    if result.success
      start_new_session_for result.object
      redirect_to root_path, notice: "E-mail confirmado! Bem-vindo(a)."
    else
      redirect_to login_path, alert: result.error_message
    end
  end
end
