module Submissions
  class Create
    def initialize(user:, challenge:, file:)
      @user = user
      @challenge = challenge
      @file = file
    end

    def call
      return blocked_result("Esse desafio não está aberto para respostas no momento.") unless @challenge.open?
      return blocked_result("Você já resolveu esse desafio.") if @challenge.solved_by?(@user)

      submission = @challenge.submissions.create!(
        user: @user,
        file: @file,
        correct: true,
        submitted_at: Time.current
      )
      Result.new(success: true, object: submission, error_message: nil)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, object: e.record, error_message: e.record.errors.full_messages.to_sentence)
    end

    private

    def blocked_result(message)
      Result.new(success: false, object: nil, error_message: message)
    end
  end
end
