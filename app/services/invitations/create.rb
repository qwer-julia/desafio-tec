module Invitations
  class Create
    def initialize(invited_by:, email_address:)
      @invited_by = invited_by
      @email_address = email_address
    end

    def call
      # Reenviar para um convite pendente gera um novo link em vez de falhar na unicidade.
      invitation = Invitation.find_or_initialize_by(email_address: @email_address.to_s.strip.downcase)
      return already_accepted_result(invitation) if invitation.accepted?

      invitation.invited_by = @invited_by
      invitation.save!
      InvitationMailer.invite(invitation).deliver_later
      Result.new(success: true, object: invitation, error_message: nil)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, object: e.record, error_message: e.record.errors.full_messages.to_sentence)
    end

    private

    def already_accepted_result(invitation)
      Result.new(success: false, object: invitation, error_message: "Esse convite já foi aceito.")
    end
  end
end
