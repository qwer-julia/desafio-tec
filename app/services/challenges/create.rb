module Challenges
  class Create
    def initialize(created_by:, challenge_params:)
      @created_by = created_by
      @challenge_params = challenge_params
    end

    def call
      challenge = Challenge.new(@challenge_params)
      challenge.created_by = @created_by
      challenge.save!
      Result.new(success: true, object: challenge, error_message: nil)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, object: e.record, error_message: e.record.errors.full_messages.to_sentence)
    end
  end
end
