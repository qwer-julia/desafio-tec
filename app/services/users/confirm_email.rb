module Users
  class ConfirmEmail
    def initialize(token:)
      @token = token
    end

    def call
      user = User.find_by_token_for(:email_confirmation, @token)
      return invalid_token_result unless user

      user.update!(confirmed_at: Time.current)
      Result.new(success: true, object: user, error_message: nil)
    end

    private

    def invalid_token_result
      Result.new(success: false, object: nil, error_message: "Link de confirmação inválido ou expirado.")
    end
  end
end
