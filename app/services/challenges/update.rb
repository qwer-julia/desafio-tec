module Challenges
  class Update
    def initialize(challenge:, challenge_params:)
      @challenge = challenge
      @challenge_params = challenge_params
    end

    def call
      @challenge.update!(@challenge_params)
      Result.new(success: true, object: @challenge, error_message: nil)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, object: e.record, error_message: e.record.errors.full_messages.to_sentence)
    end
  end
end
