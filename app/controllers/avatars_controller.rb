class AvatarsController < ApplicationController
  def edit
  end

  def update
    if Current.user.update(avatar_params)
      redirect_to scoreboard_user_path(Current.user), notice: "Avatar atualizado."
    else
      flash.now[:alert] = "Não foi possível salvar o avatar."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def avatar_params
    permitted = params.fetch(:user, {}).permit(:avatar_costume, avatar_accessories: [])
    permitted[:avatar_costume] = permitted[:avatar_costume].presence
    permitted[:avatar_accessories] = Array(permitted[:avatar_accessories]).compact_blank
    permitted
  end
end
