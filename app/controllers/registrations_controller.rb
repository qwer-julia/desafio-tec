class RegistrationsController < ApplicationController
  layout "guest"
  allow_unauthenticated_access
  before_action :set_invitation

  def new
    @user = User.new(email_address: @invitation.email_address)
  end

  def create
    result = Users::Register.new(invitation: @invitation, user_params: user_params).call

    if result.success
      start_new_session_for result.object
      redirect_to root_path, notice: "Conta criada! Bem-vindo(a)."
    else
      @user = result.object
      flash.now[:alert] = result.error_message
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find_by_token_for(:acceptance, params[:token])
    redirect_to login_path, alert: "Convite inválido ou expirado. Peça um novo convite a um admin." unless @invitation
  end

  def user_params
    params.expect(user: [ :name, :password, :password_confirmation ])
  end
end
