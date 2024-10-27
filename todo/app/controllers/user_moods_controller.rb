class UserMoodsController < ApplicationController
  before_action :authenticate_user!

  def update_user_moods
    mood_service = Moods::UserMoodUpdateService.new(current_user, params[:mood_id])

    if mood_service.call
      render_success(theme_mood: mood_service.theme_mood_data)
    else
      render_error(mood_service.error_message, :unprocessable_entity)
    end
  end

end
