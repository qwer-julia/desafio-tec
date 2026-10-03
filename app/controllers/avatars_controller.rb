class AvatarsController < ApplicationController
  def show
  end

  def update
    if Current.user.update(avatar_params)
      redirect_to avatar_path, notice: "Avatar atualizado."
    else
      flash.now[:alert] = "Não foi possível salvar o avatar."
      render :show, status: :unprocessable_entity
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
