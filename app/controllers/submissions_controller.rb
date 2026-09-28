class SubmissionsController < ApplicationController
  before_action :set_challenge

  def create
    result = Submissions::Create.new(user: Current.user, challenge: @challenge, file: params[:file]).call

    if result.success
      redirect_to challenge_path(@challenge), notice: "Entrega recebida! Você ganhou 1 ponto."
    else
      redirect_to challenge_path(@challenge), alert: result.error_message
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find_by!(slug: params[:challenge_id])
  end
end
