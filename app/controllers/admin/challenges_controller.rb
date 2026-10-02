module Admin
  class ChallengesController < ApplicationController
    before_action :require_admin
    before_action :set_challenge, only: %i[ edit update ]

    def new
      @challenge = Challenge.new(starts_at: next_monday, ends_at: next_monday + 1.week)
    end

    def create
      result = Challenges::Create.new(created_by: Current.user, challenge_params: challenge_params).call

      if result.success
        redirect_to challenge_path(result.object), notice: "Desafio criado com sucesso."
      else
        @challenge = result.object
        flash.now[:alert] = result.error_message
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      result = Challenges::Update.new(challenge: @challenge, challenge_params: challenge_params).call

      if result.success
        redirect_to challenge_path(result.object), notice: "Desafio atualizado com sucesso."
      else
        flash.now[:alert] = result.error_message
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def require_admin
      redirect_to root_path, alert: "Você não tem permissão para acessar essa página.", status: :see_other unless Current.user.admin?
    end

    def set_challenge
      @challenge = Challenge.find_by!(slug: params[:id])
    end

    def challenge_params
      params.expect(challenge: [ :title, :description, :starts_at, :ends_at, :prize_name, :prize_image, :interns_only ])
    end

    def next_monday
      Date.current.next_occurring(:monday).beginning_of_day
    end
  end
end
