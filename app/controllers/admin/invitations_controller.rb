module Admin
  class InvitationsController < ApplicationController
    before_action :require_admin

    def new
      @invitation = Invitation.new
    end

    def create
      result = Invitations::Create.new(invited_by: Current.user, email_address: params.expect(invitation: [ :email_address ])[:email_address]).call

      if result.success
        redirect_to new_admin_invitation_path, notice: "Convite enviado para #{result.object.email_address}."
      else
        @invitation = result.object
        flash.now[:alert] = result.error_message
        render :new, status: :unprocessable_entity
      end
    end

    private

    def require_admin
      redirect_to root_path, alert: "Você não tem permissão para acessar essa página.", status: :see_other unless Current.user.admin?
    end
  end
end
