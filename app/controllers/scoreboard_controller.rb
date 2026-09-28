class ScoreboardController < ApplicationController
  def show
    @ranked_users = User.ranked_by_points
  end
end
