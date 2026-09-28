module Users
  class Register
    def initialize(invitation:, user_params:)
      @invitation = invitation
      @user_params = user_params
    end

    def call
      user = User.new(@user_params)
      user.email_address = @invitation.email_address
      # O link do convite já comprova a posse do e-mail.
      user.confirmed_at = Time.current

      ActiveRecord::Base.transaction do
        user.save!
        @invitation.update!(accepted_at: Time.current)
      end

      Result.new(success: true, object: user, error_message: nil)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, object: user, error_message: e.record.errors.full_messages.to_sentence)
    end
  end
end
