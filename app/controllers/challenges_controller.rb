class ChallengesController < ApplicationController
  def index
    @current_challenge = Challenge.current
    @upcoming_challenges = Challenge.upcoming
    @past_challenges = Challenge.past.reverse_order
  end

  def show
    @challenge = Challenge.find_by!(slug: params[:id])
    @solvers = @challenge.solvers
    @my_submission = @challenge.submission_for(Current.user)
  end
end
