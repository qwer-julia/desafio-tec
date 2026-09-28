class CalendarsController < ApplicationController
  def mine
    @challenges = Challenge.where("starts_at <= ?", Time.current).ordered.reverse_order
    @solved_challenge_ids = Current.user.submissions.where(correct: true).pluck(:challenge_id).to_set
  end

  def team
    submissions = Submission.where(correct: true).includes(:user, :challenge).order(:submitted_at)
    @submissions_by_day = submissions.group_by { |submission| submission.submitted_at.to_date }

    first_day = [ Challenge.minimum(:starts_at), submissions.first&.submitted_at ].compact.min&.to_date || Date.current
    @months = (first_day.beginning_of_month..Date.current.beginning_of_month).select { |day| day.day == 1 }.reverse
  end
end
