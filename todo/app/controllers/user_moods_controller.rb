class UserMoodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mood, only: [:destroy]

  # Adiciona um humor ao usuário
  def create
    mood = Mood.find(params[:mood_id])

    if current_user.moods.include?(mood)
      render_error('Humor já selecionado.', :unprocessable_entity)
    else
      current_user.moods << mood
      render_success
    end
  rescue ActiveRecord::RecordNotFound
    render_not_found('Humor')
  end

  # Remove um humor do usuário
  def destroy
    if current_user.moods.delete(@mood)
      render_success
    else
      render_error('Não foi possível remover o humor.', :unprocessable_entity)
    end
  end

  # Atualiza o humor ativo do usuário
  def update_user_moods
    mood_service = UserMoodUpdateService.new(current_user, params[:mood_id])

    if mood_service.call
      render_success(theme_mood: mood_service.theme_mood_data)
    else
      render_error(mood_service.error_message, :unprocessable_entity)
    end
  end

  private

  def set_mood
    @mood = find_record(Mood, params[:id], 'Humor')
  end
end
