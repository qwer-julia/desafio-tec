class ChallengesController < ApplicationController
  def index
    @current_challenges = Challenge.open_now.with_attached_prize_image
    @prize_challenges = @current_challenges.select { |challenge| challenge.prize_image.attached? }
      .uniq { |challenge| [ challenge.prize_name.to_s.strip, challenge.prize_image.blob.checksum ] }
    @upcoming_challenges = Challenge.upcoming
    @past_challenges = Challenge.past.reverse_order
  end

  def show
    @challenge = Challenge.find_by!(slug: params[:id])
    @solvers = @challenge.solvers
    @my_submission = @challenge.submission_for(Current.user)
  end
end
