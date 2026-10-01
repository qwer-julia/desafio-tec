class ScoreboardController < ApplicationController
  before_action :set_user, only: %i[ user download ]

  def show
    @ranked_users = User.ranked_by_points
  end

  def user
    @challenges = Challenge.where("starts_at <= ?", Time.current).ordered.reverse_order
    @submissions_by_challenge_id = @user.submissions.where(correct: true).order(:submitted_at).index_by(&:challenge_id)
  end

  def download
    challenge = Challenge.find_by!(slug: params[:challenge_id])
    return redirect_to scoreboard_user_path(@user), alert: "O desafio ainda está aberto." if challenge.open?

    submission = challenge.submission_for(@user)
    return redirect_to scoreboard_user_path(@user), alert: "Entrega não encontrada." unless submission&.file&.attached?

    send_data submission.file.download,
      filename: submission.file.filename.to_s,
      type: submission.file.content_type,
      disposition: "attachment"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
