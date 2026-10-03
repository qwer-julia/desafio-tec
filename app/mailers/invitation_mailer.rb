class InvitationMailer < ApplicationMailer
  def invite(invitation)
    @invitation = invitation
    @token = invitation.generate_token_for(:acceptance)
    mail subject: "Você foi convidado(a) para a Rataria", to: invitation.email_address
  end
end
