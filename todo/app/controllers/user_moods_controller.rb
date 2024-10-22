class UserMoodsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_mood, only: [:destroy]
  
    # Adiciona um humor ao usuário
    def create
      mood = Mood.find(params[:mood_id])
      
      if current_user.moods.include?(mood)
        render json: { success: false, error: 'Humor já selecionado.' }, status: :unprocessable_entity
      else
        current_user.moods << mood
        render json: { success: true }
      end
    rescue ActiveRecord::RecordNotFound
      render json: { success: false, error: 'Humor não encontrado.' }, status: :not_found
    end
  
    # Remove um humor do usuário
    def destroy
      if current_user.moods.delete(@mood)
        render json: { success: true }
      else
        render json: { success: false, error: 'Não foi possível remover o humor.' }, status: :unprocessable_entity
      end
    end
    

    def update_user_moods
      selected_mood_id = params[:mood_id]
      current_user.user_moods.update_all(active: false)
      user_mood = current_user.user_moods.find_or_initialize_by(mood_id: selected_mood_id)
      user_mood.active = true
    
      if user_mood.save
        # Busca o theme_mood correspondente
        theme_mood = ThemeMood.find_by(mood_id: selected_mood_id, mood_category_id: current_user.mood_category_id)
    
        render json: { success: true, theme_mood: { image_url: theme_mood.image_url, message: theme_mood.message } }
      else
        render json: { success: false, error: user_mood.errors.full_messages.join(", ") }
      end
    end
    
  
    private
  
    def set_mood
      @mood = Mood.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { success: false, error: 'Humor não encontrado.' }, status: :not_found
    end
  end
  